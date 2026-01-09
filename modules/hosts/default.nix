# Host Configuration Module
#
# This module provides the option system for defining NixOS hosts and generates
# the corresponding `nixosConfigurations` for each defined host.
#
# Host definitions are loaded from separate files (e.g., kokosa.nix) for modularity.
{
  config,
  inputs,
  lib,
  withSystem,
  ...
}: let
  inherit (lib) mkOption types hasPrefix;

  # Get all registered NixOS module names
  nixosModules = builtins.attrNames (config.flake.modules.nixos or {});

  # Filter out host-specific modules (those prefixed with "hosts/")
  # to get only the common/shared modules that can be referenced by hosts
  commonModules = builtins.filter (name: !hasPrefix "hosts/" name) nixosModules;
in {
  # Import host-specific configurations
  imports = [
    ./kokosa.nix
  ];

  # hosts.nixos :: AttrSet<HostName, HostConfig>
  # Define the schema for host configurations
  options.hosts.nixos = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          # system :: String (must be one of config.systems)
          # Target system architecture (e.g., "x86_64-linux")
          system = mkOption {
            type = types.enum config.systems;
            example = "x86_64-linux";
            description = "Target system architecture for this host.";
          };

          # useHomeManager :: Bool
          # Whether to enable Home Manager integration
          useHomeManager = mkOption {
            type = types.bool;
            default = true;
            description = "Include Home Manager support for this host.";
          };

          # modules :: [String]
          # List of common module names to include
          modules = mkOption {
            type = types.listOf (types.enum commonModules);
            default = [];
            description = ''
              List of NixOS modules (by name) to include for this host.

              Host-scoped modules (`hosts/<name>`) are added automatically.
            '';
          };
        };
      }
    );
    default = {};
    description = "Defined NixOS hosts built from shared modules.";
  };

  # Generate nixosConfigurations from host definitions
  # mapAttrs :: (String -> HostConfig -> NixOSConfiguration) -> AttrSet -> AttrSet
  config.flake.nixosConfigurations =
    builtins.mapAttrs (
      name: host:
        withSystem host.system (
          {...}:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {inherit inputs;};

              modules = let
                # Construct the host-specific module name
                hostModuleName = "hosts/${name}";

                # Look up the host module, throw if not found
                hostModule =
                  if config.flake.modules.nixos ? "hosts/${name}"
                  then config.flake.modules.nixos."hosts/${name}"
                  else throw "Host module `${hostModuleName}` is not defined.";
              in [
                # Import all selected common modules
                {
                  imports =
                    builtins.map (
                      moduleName:
                        config.flake.modules.nixos.${moduleName}
                        or (throw "Unknown NixOS module `${moduleName}`.")
                    )
                    host.modules;
                }
                # Conditionally add Home Manager support
                (
                  if host.useHomeManager
                  then {imports = [inputs.home-manager.nixosModules.home-manager];}
                  else {}
                )
                # Include the host-specific module
                hostModule
              ];
            }
        )
    )
    config.hosts.nixos;
}
