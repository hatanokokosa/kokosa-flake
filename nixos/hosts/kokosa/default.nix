{nixosProfiles, ...}: {
  imports = [
    nixosProfiles.base
    nixosProfiles.china-network
    nixosProfiles.creator
    nixosProfiles.development
    nixosProfiles.gaming
    nixosProfiles.graphical
    nixosProfiles.music
    nixosProfiles.performance
    nixosProfiles.remote-access
    nixosProfiles.tablet
    nixosProfiles.virtualisation

    ../../modules/hardware/amd-gpu.nix
    ../../modules/services/paseo.nix
    ../../modules/secrets.nix
    ./hardware.nix
  ];

  networking.firewall.enable = false;

  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgl+EIk/QAxExeVE5hAkhTXLwPQtv2dXYpBZFoGVeSB";
  vaultix.secrets.warp-endpoint = {};

  networking.hostName = "kokosa";
  system.stateVersion = "24.11";
}
