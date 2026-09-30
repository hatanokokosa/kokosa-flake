{...}: {
  imports = [
    ../modules/services/hysteria2.nix
    ../modules/services/mail-autoconfig.nix
    ../modules/services/mailserver.nix
    ../modules/services/mta-sts.nix
  ];
}
