{...}: {
  imports = [
    ../modules/desktop
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/graphics.nix
    ../modules/packages/daily
    ../modules/packages/editor.nix
  ];

  home-manager.users.hatano.imports = [../../home/profiles/graphical.nix];
}
