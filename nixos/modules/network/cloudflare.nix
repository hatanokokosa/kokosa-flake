{
  config,
  lib,
  pkgs,
  ...
}: let
  refreshEndpoint = pkgs.writeShellApplication {
    name = "warp-endpoint-refresh";
    runtimeInputs = [
      config.services.cloudflare-warp.package
      pkgs.coreutils
      pkgs.getent
      pkgs.jq
    ];
    text = builtins.readFile ./warp-endpoint-refresh.sh;
  };
in {
  services.cloudflare-warp.enable = true;

  systemd.services.warp-endpoint-refresh = {
    description = "Refresh the WARP acceleration entrance from DNS";
    after = ["network-online.target" "cloudflare-warp.service" "vaultix-activate.service"];
    wants = ["network-online.target"];
    requires = ["cloudflare-warp.service" "vaultix-activate.service"];
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.vaultix.secrets.warp-endpoint.path;
      ExecStart = lib.getExe refreshEndpoint;
      TimeoutStartSec = "100s";
    };
  };

  systemd.timers.warp-endpoint-refresh = {
    description = "Keep the WARP acceleration entrance current";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitInactiveSec = "2min";
      RandomizedDelaySec = "15s";
      AccuracySec = "1s";
    };
  };
}
