{...}: {
  imports = [
    ./networkmanager.nix
    ./clash-verge.nix
    ./cloudflare.nix
    ./firewall.nix
    ./ssh.nix
  ];
}
