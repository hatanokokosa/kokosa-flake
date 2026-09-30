{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = lib.head config.mailserver.domains;
  acmeCert = config.mailserver.x509.useACMEHost;

  # Testing first: senders report TLS failures instead of refusing delivery.
  # Flip to enforce once the TLS-RPT reports stay clean.
  policy = pkgs.writeText "mta-sts-${domain}.txt" ''
    version: STSv1
    mode: testing
    mx: ${config.mailserver.fqdn}
    max_age: 86400
  '';
in {
  security.acme.certs."${acmeCert}".extraDomainNames = ["mta-sts.${domain}"];

  services.nginx.virtualHosts."mta-sts.${domain}" = {
    forceSSL = true;
    useACMEHost = acmeCert;
    locations."= /.well-known/mta-sts.txt".alias = policy;
  };
}
