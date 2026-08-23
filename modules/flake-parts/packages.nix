{inputs, ...}: {
  # overlays
  flake.overlays = {
    default = final: prev: {
      # Subtitle Edit 5.0.0 (from ShadowRZ/nixpkgs shadowrz/subtitleedit-5 branch, upstream nixpkgs still on 4.0.16)
      subtitleedit = prev.callPackage "${inputs.self}/pkgs/subtitle-edit" {};
      kokosa-mono = prev.callPackage "${inputs.self}/pkgs/kokosa-mono.nix" {};
      # audio.cpp with ROCm/HIP for AMD RX 7900 XT (RDNA 3, gfx1100)
      audiocpp = prev.callPackage "${inputs.self}/pkgs/audio.cpp.nix" {
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
          omp = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.omp;
          dsh = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system}.dsh;
        })
      ];
    in
      builtins.foldl' (acc: overlay: acc // (overlay final (prev // acc))) {} overlays;
  };
}
