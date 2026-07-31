{...}: {
  imports = [
    ../modules/boot/grub.nix
    ../modules/boot/zram.nix
    ../modules/core/locale.nix
    ../modules/desktop/shell.nix
    ../modules/home.nix
    ../modules/network/firewall.nix
    ../modules/network/networkmanager.nix
    ../modules/nix
    ../modules/packages/cli
    ../modules/secrets.nix
    ../modules/security.nix
    ../modules/services/flatpak.nix
    ../modules/users.nix
  ];

  programs.nano.enable = false;
  home-manager.users.hatano.imports = [../../home/profiles/base.nix];
}
