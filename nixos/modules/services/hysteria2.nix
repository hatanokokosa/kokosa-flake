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
  subDir = "/var/lib/irisu-subscription";

  # Rendered at runtime: the password cannot be baked into the store.
  subscriptionTemplate = pkgs.writeText "irisu-hy2-subscription.yaml" ''
    proxies:
      - name: irisu-hy2
        type: hysteria2
        server: ${node}
        port: 443
        password: "@PASSWORD@"
        sni: ${node}
        up: "50 Mbps"
        down: "200 Mbps"
        # dialer-proxy: <your airport node or proxy group>
    proxy-groups:
      - name: irisu
        type: select
        proxies: ["irisu-hy2"]
    rules:
      - MATCH,irisu
  '';

  renderSubscription = pkgs.writeShellApplication {
    name = "irisu-subscription";
    runtimeInputs = [pkgs.coreutils pkgs.gnused];
    text = ''
      password=$(cat ${config.age.secrets.hy2-password.path})
      # The file name doubles as the access token, so it must not be guessable.
      token=$(printf %s "$password" | sha256sum | cut -c1-32)
      rm -f ${subDir}/*.yaml
      sed "s|@PASSWORD@|$password|" ${subscriptionTemplate} >"${subDir}/$token.yaml"
      chmod 0644 "${subDir}/$token.yaml"
    '';
  };
in {
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
              password = {_secret = config.age.secrets.hy2-password.path;};
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

  systemd.services.irisu-subscription = {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe renderSubscription;
      StateDirectory = "irisu-subscription";
      StateDirectoryMode = "0755";
    };
  };

  services.nginx.virtualHosts."${domain}".locations."/sub/".alias = "${subDir}/";
}
