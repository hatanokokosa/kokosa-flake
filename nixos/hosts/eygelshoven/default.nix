{
  config,
  inputs,
  lib,
  nixosProfiles,
  pkgs,
  ...
}: {
  imports = [
    nixosProfiles.server
    ../../modules/secrets.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware.nix
  ];

  # Skrime boots the guest with SeaBIOS, so GRUB installs to the MBR; disko
  # derives the device from the EF02 partition.
  boot.loader.grub.enable = true;
  boot.kernelParams = ["net.ifnames=0"];
  boot.kernel.sysctl = {
    "net.ipv6.conf.eth0.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
  };

  networking = {
    hostName = "eygelshoven";
    useDHCP = false;
    defaultGateway = "5.83.158.1";
    nameservers = ["1.1.1.1" "2606:4700:4700::1111"];
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "5.83.158.177";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a14:7c0:1002:1f5d::1";
          prefixLength = 64;
        }
      ];
      # The gateway lives outside the assigned /64, so the default route has
      # to be onlink.
      ipv6.routes = [
        {
          address = "::";
          prefixLength = 0;
          via = "2a14:7c0:1000::1";
          options.onlink = "";
        }
      ];
    };
  };

  time.timeZone = lib.mkForce "Europe/Amsterdam";

  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "prohibit-password";
    AuthenticationMethods = "publickey";
    X11Forwarding = false;
  };

  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPS7BA9tfwg2eoq7+OQ27KgyZvEQZ8cACeYA8bgW7Jk";
  vaultix.secrets.cloudflared-eygelshoven = {};
  vaultix.secrets.restic-r2 = {};

  services.cloudflared = {
    enable = true;
    tunnels."70850bc4-e134-425a-b3a6-13af2d2e0602" = {
      credentialsFile = config.vaultix.secrets.cloudflared-eygelshoven.path;
      warp-routing.enabled = true;
      ingress = {
        "vault.kokosa.de" = "http://127.0.0.1:8222";
        "beszel.kokosa.de" = "http://127.0.0.1:8090";
      };
      default = "http_status:404";
    };
  };

  services.vaultwarden = {
    enable = true;
    domain = "vault.kokosa.de";
    backupDir = "/var/backup/vaultwarden";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
      SENDS_ALLOWED = true;
    };
  };
  systemd.services.vaultwarden.serviceConfig.MemoryHigh = "256M";

  services.beszel.hub = {
    enable = true;
    host = "127.0.0.1";
    port = 8090;
    environment.APP_URL = "https://beszel.kokosa.de";
  };
  systemd.services.beszel-hub.serviceConfig.MemoryHigh = "192M";

  services.beszel.agent = {
    enable = true;
    environment = {
      LISTEN = "127.0.0.1:45876";
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8FlBoI98lqR1QAzD3CmYRPzpf0arhhZS5puzV2X1fN";
    };
  };
  systemd.services.beszel-agent.serviceConfig.MemoryHigh = "96M";

  services.restic.backups.r2 = {
    repository = "s3:https://ff79f31ebf5f3c892a71005a5f0b9345.r2.cloudflarestorage.com/eygelshoven-restic";
    environmentFile = config.vaultix.secrets.restic-r2.path;
    paths = [
      "/var/backup/vaultwarden"
      "/var/lib/private/beszel-hub"
    ];
    initialize = true;
    timerConfig = {
      OnCalendar = "03:15";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
  systemd.services.restic-backups-r2.serviceConfig.MemoryHigh = "512M";

  users.mutableUsers = false;
  users.users.root = {
    shell = pkgs.fish;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm92O2/2O5zGkX0EG27cZRsNmG7ZdLf8jKPfdpIPK1j wuyumagician@gmail.com"
    ];
  };

  # Pinning nixpkgs in the registry and NIX_PATH drags the whole source tree
  # into the closure, which this host does not have room for.
  nixpkgs.flake = {
    setNixPath = false;
    setFlakeRegistry = false;
  };

  nix.settings.max-jobs = 1;
  system.stateVersion = "26.05";
}
