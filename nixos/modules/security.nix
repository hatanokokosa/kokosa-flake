{...}: {
  security = {
    pam.services.systemd-run0 = {};
    sudo.enable = false;
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
