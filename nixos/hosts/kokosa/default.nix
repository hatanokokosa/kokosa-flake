{nixosModules, ...}: {
  # import modules
  imports = [
    nixosModules.security
    nixosModules.packages
    nixosModules.services
    nixosModules.secrets
    nixosModules.network
    nixosModules.desktop
    nixosModules.users
    nixosModules.boot
    nixosModules.home
    nixosModules.nix
    nixosModules.vm
    ./hardware.nix
  ];

  networking.hostName = "kokosa";
  system.stateVersion = "24.11";
}
