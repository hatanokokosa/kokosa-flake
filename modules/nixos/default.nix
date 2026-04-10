# NixOS Module Auto-Discovery
#
# This module uses lib/default.nix to discover and register NixOS modules.
{inputs, ...}: let
  utils = import "${inputs.self}/lib";
  sharedDir = "${inputs.self}/nixos/modules";
in {
  # Discover shared modules (boot, network, desktop, etc.)
  flake.modules.nixos = utils.discoverModules sharedDir;
}
