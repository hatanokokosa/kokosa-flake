{...}: {
  imports = [
    ../modules/boot/zram.nix
    ../modules/core/journald.nix
    ../modules/core/locale.nix
    ../modules/network/fail2ban.nix
    ../modules/network/firewall.nix
    ../modules/network/ssh.nix
    ../modules/nix/gc.nix
    ../modules/nix/settings.nix
  ];
}
