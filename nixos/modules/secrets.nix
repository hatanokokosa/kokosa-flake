{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    cloudflare-dns.file = inputs.self + "/secrets/cloudflare-dns.age";
    mail-kks.file = inputs.self + "/secrets/mail-kks.age";
  };
}
