{
  config,
  lib,
  pkgs,
  ...
}: let
  acmeCert = config.mailserver.x509.useACMEHost;
  certDir = "/var/lib/acme/${acmeCert}";
  domain = lib.head config.mailserver.domains;
  node = "hy2.${domain}";
in {
  imports = [../secrets.nix];

  vaultix.secrets.hy2-password = {};

  security.acme.certs."${acmeCert}".extraDomainNames = [node];

  # sing-box serves the certificate that postfix, dovecot and nginx already use.
  users.users.sing-box.extraGroups = ["acme"];

  networking.firewall.allowedUDPPorts = [443];

  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "hysteria2";
          tag = "hy2";
          listen = "::";
          listen_port = 443;
          users = [
            {
              name = "kks";
              password = {_secret = config.vaultix.secrets.hy2-password.path;};
            }
          ];
          tls = {
            enabled = true;
            certificate_path = "${certDir}/fullchain.pem";
            key_path = "${certDir}/key.pem";
          };
        }
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
      ];
      route.final = "direct";
    };
  };

  # The generated pre-start reads the password file, which vaultix writes at activation.
  systemd.services.sing-box = {
    after = ["vaultix-activate.service"];
    requires = ["vaultix-activate.service"];
    serviceConfig.ExecStartPre = lib.mkAfter [
      "+${pkgs.writeShellScript "sing-box-password-present" ''
        if ! test -s ${config.vaultix.secrets.hy2-password.path}; then
          echo "sing-box: hysteria2 password is empty" >&2
          exit 1
        fi
      ''}"
    ];
  };
}
