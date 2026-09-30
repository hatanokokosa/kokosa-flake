{...}: {
  imports = [
    ../modules/boot/zram.nix
    ../modules/core/locale.nix
    ../modules/network/firewall.nix
    ../modules/network/ssh.nix
    ../modules/nix/settings.nix
  ];
}
