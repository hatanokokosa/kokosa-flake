{inputs, ...}: {
  # overlays
  flake.overlays = {
    default = final: prev: {
      kokosa-mono = prev.callPackage "${inputs.self}/pkgs/kokosa-mono.nix" {};
      # audio.cpp with ROCm/HIP for AMD RX 7900 XT (RDNA 3, gfx1100)
      audiocpp = prev.callPackage "${inputs.self}/pkgs/audio-cpp.nix" {
        rocmSupport = true;
        rocmGpuTargets = ["gfx1100"];
      };
    };

    # all overlays
    all = final: prev: let
      overlays = [
        inputs.self.overlays.default
        inputs.nur.overlays.default
        (f: p: {
          hid-bpf-uclogic = inputs.hid-bpf-uclogic.packages.${prev.stdenv.hostPlatform.system}.default;
          dsh = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.dsh;
          omp = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.omp.override {
            bun = prev.bun.overrideAttrs (_: {
              version = "1.3.13";
              src = prev.fetchurl {
                url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-linux-x64-baseline.zip";
                hash = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
              };
            });
          };
        })
      ];
    in
      builtins.foldl' (acc: overlay: acc // (overlay final (prev // acc))) {} overlays;
  };
}
