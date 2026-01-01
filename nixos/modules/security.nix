{
  lib,
  pkgs,
  ...
}: {
  security = {
    # Enable Systemd-run0
    pam.services.systemd-run0 = {};

    # No Sudo
    sudo.enable = false;

    # OpenDoas
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["hatano"];
          keepEnv = false;
          noPass = true;
        }
      ];
    };

    # Sparkle (forked from clash-party)
    wrappers.sparkle = {
      capabilities = "cap_net_bind_service,cap_net_admin=+ep";
      source = "${lib.getExe pkgs.sparkle}";
      owner = "root";
      group = "root";
    };
  };
}
