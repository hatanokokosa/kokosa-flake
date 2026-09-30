{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    cloudflare-dns.file = inputs.self + "/secrets/cloudflare-dns.age";
    hy2-password.file = inputs.self + "/secrets/hy2-password.age";
    mail-kks.file = inputs.self + "/secrets/mail-kks.age";
  };
}
