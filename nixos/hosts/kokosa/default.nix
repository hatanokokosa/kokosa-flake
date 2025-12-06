{...}: {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "kokosa";
  system.stateVersion = "24.11";
}
