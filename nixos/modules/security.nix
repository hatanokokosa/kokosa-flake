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
  };
}
