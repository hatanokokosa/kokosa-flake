{
  inputs,
  lib,
  nixosProfiles,
  ...
}: {
  imports = [
    nixosProfiles.mail
    nixosProfiles.server

    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware.nix
  ];

  # disko sets boot.loader.grub.devices from the EF02 partition in disko.nix;
  # setting boot.loader.grub.device here would install GRUB to it twice.
  boot.loader.grub.enable = true;

  # DediRock hands out addressing statically on eth0 and boots with net.ifnames=0;
  # DHCP is not configured on the image, so the host must not rely on it.
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

  # The shared ssh module keeps password authentication available for the
  # desktop; this host accepts keys only, including over PAM keyboard-interactive.
  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce false;
    KbdInteractiveAuthentication = lib.mkForce false;
  };

  networking.hostName = "irisu";
  time.timeZone = lib.mkForce "UTC";
  system.stateVersion = "26.11";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm92O2/2O5zGkX0EG27cZRsNmG7ZdLf8jKPfdpIPK1j wuyumagician@gmail.com"
  ];
}
