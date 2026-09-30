let
  master = "age1utasugq63v8spf2jlyjk3ma5l7c68f60qnug9n7swf459p4wrudqv48u48";
  irisu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+RXfMeaQ7IwZ4GhD0Vj/LA3J/H3WoE7PlQOq9yPANh";
in {
  "secrets/cloudflare-dns.age".publicKeys = [master irisu];
  "secrets/hy2-password.age".publicKeys = [master irisu];
  "secrets/mail-kks.age".publicKeys = [master irisu];
}
