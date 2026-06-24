let
  master = "age1utasugq63v8spf2jlyjk3ma5l7c68f60qnug9n7swf459p4wrudqv48u48";
  kokosa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgl+EIk/QAxExeVE5hAkhTXLwPQtv2dXYpBZFoGVeSB";
in {
  "secrets/syncthing-gui-password.age".publicKeys = [
    master
    kokosa
  ];
  "secrets/mihomo-subscription.age".publicKeys = [
    master
    kokosa
  ];
}
