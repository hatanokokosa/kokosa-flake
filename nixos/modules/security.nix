{...}: {
  security = {
    # systemd-run0
    pam.services.systemd-run0 = {};
    sudo.enable = false;

    # opendoas
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
