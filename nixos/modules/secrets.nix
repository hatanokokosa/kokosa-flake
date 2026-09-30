{inputs, ...}: {
  imports = [inputs.vaultix.nixosModules.default];

  # vaultix hooks its activation into systemd-sysusers; userborn is the variant
  # that creates normal users too, which systemd-sysusers does not.
  services.userborn.enable = true;
}
