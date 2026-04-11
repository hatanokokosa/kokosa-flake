{
  inputs,
  config,
  ...
}: {
  # expose pkgs with custom config (allowUnfree, etc.) as legacyPackages
  # this enables `nix shell self#xxx` to use unfree packages directly
  flake.legacyPackages = builtins.listToAttrs (map (system: {
      name = system;
      value = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [inputs.self.overlays.all];
      };
    })
    config.systems);
}
