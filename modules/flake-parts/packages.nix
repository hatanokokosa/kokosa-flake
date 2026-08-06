{inputs, ...}: {
  # overlays
  flake.overlays = {
    default = final: prev: let
      # nixpkgs bug: python3Packages.steamworkspy fails pythonMetadataCheckPhase
      # because the upstream repo's setup.py declares name = "steamworks" (so no
      # steamworkspy dist-info is installed) and the derivation version is a git
      # rev that can never match the metadata version. Not fixed upstream as of
      # 2026-08; skip the check until upstream patches it.
      # Note: python3Packages is defined as python314.pkgs and does not follow
      # the python3 alias, so python314 must be overridden (python3 too, for
      # python3.pkgs consumers).
      steamworkspyOverride = {
        packageOverrides = python-final: python-prev: {
          steamworkspy = python-prev.steamworkspy.overridePythonAttrs (old: {
            dontCheckPythonMetadata = true;
          });
        };
      };
    in {
      kokosa-mono = prev.callPackage "${inputs.self}/pkgs/kokosa-mono.nix" {};

      python314 = prev.python314.override steamworkspyOverride;
      python3 = prev.python3.override steamworkspyOverride;
    };

    # all overlays
    all = final: prev: let
      overlays = [
        inputs.self.overlays.default
        inputs.nur.overlays.default
        (f: p: {
          hid-bpf-uclogic = inputs.hid-bpf-uclogic.packages.${prev.stdenv.hostPlatform.system}.default;
          omp = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.omp;
        })
      ];
    in
      builtins.foldl' (acc: overlay: acc // (overlay final (prev // acc))) {} overlays;
  };
}
