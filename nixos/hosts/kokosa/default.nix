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
    ./hardware.nix
  ];

  # Preserve the current trusted-network policy for this desktop.
  networking.firewall.enable = false;

  networking.hostName = "kokosa";
  system.stateVersion = "24.11";
}
