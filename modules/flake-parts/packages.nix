{inputs, ...}: {
  flake.overlays.default = final: prev: {
    kokosa-mono = prev.callPackage "${inputs.self}/pkgs/kokosa-mono.nix" {};
  };

  perSystem = {pkgs, ...}: {
    packages.kokosa-mono = pkgs.callPackage "${inputs.self}/pkgs/kokosa-mono.nix" {};
  };
}
