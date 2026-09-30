{
  inputs,
  lib,
  nixosProfiles,
  pkgs,
  ...
}: {
  imports = [
    nixosProfiles.mail
    nixosProfiles.server

    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware.nix
  ];

  boot.loader.grub.enable = true;

  boot.kernelParams = ["net.ifnames=0"];

  networking = {
    useDHCP = false;
    defaultGateway = "107.150.26.1";
    nameservers = ["8.8.8.8" "8.8.4.4"];
    interfaces.eth0.ipv4.addresses = [
      {
        address = "107.150.26.5";
        prefixLength = 26;
      }
    ];
  };

  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce false;
    KbdInteractiveAuthentication = lib.mkForce false;
  };

  networking.hostName = "irisu";
  time.timeZone = lib.mkForce "UTC";
  system.stateVersion = "26.11";

  # Per-host cache is encrypted to this key: /etc/ssh/ssh_host_ed25519_key.pub.
  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+RXfMeaQ7IwZ4GhD0Vj/LA3J/H3WoE7PlQOq9yPANh";

  # Only interactive account on this host.
  users.users.root.shell = pkgs.fish;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm92O2/2O5zGkX0EG27cZRsNmG7ZdLf8jKPfdpIPK1j wuyumagician@gmail.com"
  ];
}
