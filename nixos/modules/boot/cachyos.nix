{
  inputs,
  pkgs,
  ...
}: {
  # Keep module aggregation compatible with the pinned kernel's signing format.
  nixpkgs.overlays = [
    (_final: prev: {
      aggregateModules =
        inputs.nix-cachyos-kernel.inputs.nixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.aggregateModules;
    })
  ];

  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
}
