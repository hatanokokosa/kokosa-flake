set -euo pipefail

: "${WARP_ENTRANCE_HOST:?Set WARP_ENTRANCE_HOST in the local endpoint configuration}"
: "${WARP_ENTRANCE_PORT:?Set WARP_ENTRANCE_PORT in the local endpoint configuration}"

cli=(warp-cli --accept-tos)
settings=$("${cli[@]}" --json settings)
status=$("${cli[@]}" --json status)
original=$(jq -r '.settings.override_warp_endpoint // empty' <<< "$settings")

if jq -e '.settings.always_on == false' <<< "$settings" >/dev/null; then
  echo "WARP is disabled; leaving it off"
  exit 0
fi

resume=false
changed=false
result=0
trap '
  result=$?
  trap - EXIT
  if ((result != 0)) && $changed; then
    echo "No replacement connected; restoring the previous endpoint" >&2
    if [[ -n "$original" ]]; then
      "${cli[@]}" tunnel endpoint set "$original" || echo "Failed to restore endpoint" >&2
    else
      "${cli[@]}" tunnel endpoint reset || echo "Failed to reset endpoint" >&2
    fi
  fi
  if $resume; then
    "${cli[@]}" connect || echo "Failed to resume WARP" >&2
  fi
  exit "$result"
' EXIT
trap 'exit 143' TERM
trap 'exit 130' INT

lookup() {
  timeout 10s getent ahostsv4 "$WARP_ENTRANCE_HOST"
}

if ! records=$(lookup); then
  if jq -e '.status == "Connected" and .reason == "NetworkHealthy"' <<< "$status" >/dev/null; then
    echo "DNS lookup failed; keeping the healthy tunnel unchanged" >&2
    exit 1
  fi
  # The local WARP DNS proxy may be unreachable through a broken entrance.
  echo "Pausing the unhealthy tunnel to resolve its entrance over the local network"
  resume=true
  "${cli[@]}" disconnect
  records=$(lookup)
fi

mapfile -t addresses < <(printf '%s\n' "$records" | cut -d ' ' -f1 | sort -u)
if ((${#addresses[@]} == 0)); then
  echo "Entrance DNS returned no IPv4 addresses" >&2
  exit 1
fi

for address in "${addresses[@]}"; do
  if [[ "$original" == "$address:$WARP_ENTRANCE_PORT" ]] &&
    jq -e '.status == "Connected" and .reason == "NetworkHealthy"' <<< "$status" >/dev/null; then
    echo "Keeping healthy entrance $original"
    exit 0
  fi
done

for address in "${addresses[@]}"; do
  if [[ "$original" == "$address:$WARP_ENTRANCE_PORT" ]] && ((${#addresses[@]} > 1)); then
    continue
  fi
  changed=true
  resume=true
  echo "Connecting through $address:$WARP_ENTRANCE_PORT"
  "${cli[@]}" tunnel endpoint set "$address:$WARP_ENTRANCE_PORT"
  "${cli[@]}" connect
  for ((attempt = 0; attempt < 20; attempt++)); do
    sleep 1
    status=$("${cli[@]}" --json status)
    if jq -e '.status == "Connected" and .reason == "NetworkHealthy"' <<< "$status" >/dev/null; then
      stats=$("${cli[@]}" --json tunnel stats)
      if jq -e --arg address "$address" '.warp_is_on and .v4_endpoint == $address' <<< "$stats" >/dev/null; then
        resume=false
        echo "WARP connected through $address:$WARP_ENTRANCE_PORT"
        exit 0
      fi
    fi
  done
done

echo "None of the published WARP entrances connected" >&2
exit 1
