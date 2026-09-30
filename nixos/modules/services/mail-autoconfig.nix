{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = lib.head config.mailserver.domains;
  host = config.mailserver.fqdn;
  acmeCert = config.mailserver.x509.useACMEHost;

  thunderbirdConfig = pkgs.writeText "autoconfig-${domain}.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <clientConfig version="1.1">
      <emailProvider id="${domain}">
        <domain>${domain}</domain>
        <displayName>${domain}</displayName>
        <displayShortName>${domain}</displayShortName>
        <incomingServer type="imap">
          <hostname>${host}</hostname>
          <port>993</port>
          <socketType>SSL</socketType>
          <authentication>password-cleartext</authentication>
          <username>%EMAILADDRESS%</username>
        </incomingServer>
        <outgoingServer type="smtp">
          <hostname>${host}</hostname>
          <port>465</port>
          <socketType>SSL</socketType>
          <authentication>password-cleartext</authentication>
          <username>%EMAILADDRESS%</username>
        </outgoingServer>
        <outgoingServer type="smtp">
          <hostname>${host}</hostname>
          <port>587</port>
          <socketType>STARTTLS</socketType>
          <authentication>password-cleartext</authentication>
          <username>%EMAILADDRESS%</username>
        </outgoingServer>
      </emailProvider>
    </clientConfig>
  '';

  autodiscoverConfig = pkgs.writeText "autodiscover-${domain}.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">
      <Response xmlns="http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a">
        <Account>
          <AccountType>email</AccountType>
          <Action>settings</Action>
          <Protocol>
            <Type>IMAP</Type>
            <Server>${host}</Server>
            <Port>993</Port>
            <SSL>on</SSL>
            <LoginName>%EMAILADDRESS%</LoginName>
          </Protocol>
          <Protocol>
            <Type>SMTP</Type>
            <Server>${host}</Server>
            <Port>465</Port>
            <SSL>on</SSL>
            <LoginName>%EMAILADDRESS%</LoginName>
          </Protocol>
        </Account>
      </Response>
    </Autodiscover>
  '';
in {
  # Thunderbird asks the discovery host names first, then the well-known path.
  security.acme.certs."${acmeCert}".extraDomainNames = [
    "autoconfig.${domain}"
    "autodiscover.${domain}"
    "${domain}"
  ];

  # nginx reads the certificate issued for postfix and dovecot.
  users.users.nginx.extraGroups = ["acme"];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "autoconfig.${domain}" = {
        forceSSL = true;
        useACMEHost = acmeCert;
        locations."= /mail/config-v1.1.xml".alias = thunderbirdConfig;
      };
      "autodiscover.${domain}" = {
        forceSSL = true;
        useACMEHost = acmeCert;
        locations = {
          "= /autodiscover/autodiscover.xml".alias = autodiscoverConfig;
          "= /Autodiscover/Autodiscover.xml".alias = autodiscoverConfig;
        };
      };
      "${domain}" = {
        forceSSL = true;
        useACMEHost = acmeCert;
        locations."= /.well-known/autoconfig/mail/config-v1.1.xml".alias = thunderbirdConfig;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
