{
  stdenvNoCC,
  bash,
  bubblewrap,
  wpsoffice-cn,
}: let
  package = wpsoffice-cn;
in
  stdenvNoCC.mkDerivation {
    pname = "wps-sandbox";
    inherit (package) version;
    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin" "$out/libexec" "$out/share"
      cp -r ${package}/share/. "$out/share/"

      for app in wps et wpp wpspdf; do
        cp ${package}/bin/$app "$out/libexec/$app"
        # A launch must own its foreground process, not forward to another instance.
        if [ "$app" = wpspdf ]; then
          substituteInPlace "$out/libexec/$app" \
            --replace-fail ' /prometheus "$@"' ' /prometheus -multiply "$@"' \
            --replace-fail '/''${gApp} "$@"' '/''${gApp} -multiply "$@"'
        else
          substituteInPlace "$out/libexec/$app" \
            --replace-fail '#gOptExt=-multiply' 'gOptExt=-multiply'
        fi
        cat > "$out/bin/$app" <<EOF
      #!${bash}/bin/bash
      exec ${bubblewrap}/bin/bwrap \\
        --unshare-pid \\
        --die-with-parent \\
        --new-session \\
        --bind / / \\
        --dev-bind /dev /dev \\
        --proc /proc \\
        -- "$out/libexec/$app" "\$@"
      EOF
        chmod +x "$out/bin/$app"
      done

      for desktop in "$out/share/applications/"*.desktop; do
        substituteInPlace "$desktop" --replace-warn '${package}/bin/' "$out/bin/"
        for app in wps et wpp wpspdf; do
          substituteInPlace "$desktop" \
            --replace-warn "Exec=$app " "Exec=$out/bin/$app "
        done
      done
      runHook postInstall
    '';

    meta =
      package.meta
      // {
        description = "WPS Office with per-launch PID isolation and process cleanup";
        mainProgram = "wps";
      };
  }
