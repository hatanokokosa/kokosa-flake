{nixosModules, ...}: {
  imports = [
    nixosModules.boot
    nixosModules.desktop
    nixosModules.home
    nixosModules.network
    nixosModules.nix
    nixosModules.packages
    nixosModules.security
    nixosModules.secrets
    nixosModules.services
    nixosModules.users
    nixosModules.vm
    ./hardware.nix
  ];

  networking.hostName = "kokosa";
  system.stateVersion = "24.11";
}
