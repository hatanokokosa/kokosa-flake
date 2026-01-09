# Host configuration for kokosa
#
# This file defines the kokosa host's system architecture and module selection.
# It is separated from the host options definition for better maintainability.
{...}: {
  config.hosts.nixos.kokosa = {
    system = "x86_64-linux";
    useHomeManager = true;
    modules = [
      "services"
      "packages"
      "security"
      "secrets"
      "desktop"
      "network"
      "users"
      "home"
      "boot"
      "nix"
      "vm"
    ];
  };
}
