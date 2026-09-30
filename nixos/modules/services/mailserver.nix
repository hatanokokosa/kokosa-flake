{
  config,
  inputs,
  options,
  ...
}: {
  imports = [
    inputs.nixos-mailserver.nixosModules.default
    ../secrets.nix
  ];

  vaultix.secrets = {
    cloudflare-dns = {};
    mail-kks = {};
  };

  security.acme.acceptTerms = true;

  # DNS-01: mail.irisu.org is served from a host that also accepts mail, so the
  # challenge must not depend on an HTTP vhost. The secret holds the bare token.
  # The propagation check asks the zone's own nameserver: the local resolver
  # caches the NXDOMAIN it sees just before Cloudflare serves the new record.
  security.acme.certs."mail.irisu.org" = {
    dnsProvider = "cloudflare";
    credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE = config.vaultix.secrets.cloudflare-dns.path;
    dnsResolver = "hans.ns.cloudflare.com:53";
  };

  mailserver = {
    enable = true;
    stateVersion = 5;
    fqdn = "mail.irisu.org";
    domains = ["irisu.org"];
    openFirewall = true;
    enableSubmission = true;
    x509.useACMEHost = "mail.irisu.org";

    # The mailboxes option has no type, so a definition replaces the module
    # default wholesale; reintroduce that default and add Archive.
    mailboxes =
      (options.mailserver.mailboxes.default or {})
      // {
        Archive = {
          special_use = "\\Archive";
          auto = "subscribe";
        };
      };

    accounts."kks@irisu.org" = {
      passwordFile = config.vaultix.secrets.mail-kks.path;
      aliases = [
        "postmaster@irisu.org"
        "abuse@irisu.org"
        "dmarc@irisu.org"
        "tlsrpt@irisu.org"
      ];
    };
  };
}
