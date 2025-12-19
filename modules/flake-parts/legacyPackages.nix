{inputs, ...}: {
  # Expose pkgs with custom config (allowUnfree, CUDA, etc.) as legacyPackages.
  # This enables `nix shell self#xxx` to use unfree packages directly.
  flake.legacyPackages = builtins.listToAttrs (map (system: {
    name = system;
    value = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        inputs.self.overlays.default
        inputs.nur.overlays.default
        (final: prev: {
          hid-bpf-uclogic = inputs.hid-bpf-uclogic.packages.${system}.default;
        })
      ];
    };
  }) ["x86_64-linux"]);
}
