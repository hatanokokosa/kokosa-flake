{
  inputs,
  lib,
  nixosProfiles,
  pkgs,
  ...
}: {
  imports = [
    nixosProfiles.server
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = ["net.ifnames=0"];
  boot.kernel.sysctl = {
    "net.ipv6.conf.eth0.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
  };

  networking = {
    hostName = "toronto";
    useDHCP = false;
    defaultGateway = "149.248.62.1";
    defaultGateway6 = {
      address = "fe80::fc00:7ff:fe02:bf21";
      interface = "eth0";
    };
    nameservers = ["1.1.1.1" "2606:4700:4700::1111"];
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "149.248.63.4";
          prefixLength = 23;
        }
      ];
      ipv6.addresses = [
        {
          address = "2001:19f0:b002:e6e:5400:7ff:fe02:bf21";
          prefixLength = 64;
        }
      ];
    };
  };

  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "prohibit-password";
    AuthenticationMethods = "publickey";
    X11Forwarding = false;
  };

  users.mutableUsers = false;
  users.users.root = {
    shell = pkgs.fish;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm92O2/2O5zGkX0EG27cZRsNmG7ZdLf8jKPfdpIPK1j wuyumagician@gmail.com"
    ];
  };

  nix.settings.max-jobs = 1;
  time.timeZone = lib.mkForce "UTC";
  system.stateVersion = "26.05";
}
