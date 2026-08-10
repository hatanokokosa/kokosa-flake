{pkgs, ...}: {
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

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
