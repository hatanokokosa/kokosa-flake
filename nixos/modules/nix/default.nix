{inputs, ...}: {
  imports = [
    ./nh.nix
    ./nix-ld.nix
    ./settings.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
      inputs.self.overlays.all
    ];
  };
}
