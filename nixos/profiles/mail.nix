{...}: {
  imports = [
    ../modules/services/mail-autoconfig.nix
    ../modules/services/mailserver.nix
    ../modules/services/mta-sts.nix
  ];
}
