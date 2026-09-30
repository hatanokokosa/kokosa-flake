{pkgs, ...}: {
  services.fail2ban = {
    enable = true;
    jails = {
      sshd.settings.backend = "systemd";
      dovecot.settings.backend = "systemd";
      "postfix-sasl".settings.backend = "systemd";
    };
  };

  environment.systemPackages = [pkgs.fail2ban];
}
