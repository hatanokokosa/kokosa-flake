# NixOS Module Auto-Discovery
#
# This module uses lib/default.nix to discover and register NixOS modules.
{inputs, ...}: let
  utils = import "${inputs.self}/lib" {};
  sharedDir = "${inputs.self}/nixos/modules";
  hostsDir = "${inputs.self}/nixos/hosts";

  # Discover shared modules (boot, network, desktop, etc.)
  sharedModules = utils.discoverModules sharedDir;

  # Discover host-specific modules (hosts/kokosa, etc.)
  hostModules = utils.discoverHosts hostsDir;
in {
  flake.modules.nixos = sharedModules // hostModules;
}
