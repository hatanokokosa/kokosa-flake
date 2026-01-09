{
  config,
  inputs,
  lib,
  withSystem,
  ...
}: let
  inherit (lib) mkOption types hasPrefix;

  nixosModules = builtins.attrNames (config.flake.modules.nixos or {});
  commonModules = builtins.filter (name: !hasPrefix "hosts/" name) nixosModules;
in {
  options.hosts.nixos = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          system = mkOption {
            type = types.enum config.systems;
            example = "x86_64-linux";
            description = "Target system architecture for this host.";
          };

          useHomeManager = mkOption {
            type = types.bool;
            default = true;
            description = "Include Home Manager support for this host.";
          };

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

  config.hosts.nixos.kokosa = {
    system = "x86_64-linux";
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
    useHomeManager = true;
  };

  config.flake.nixosConfigurations =
    builtins.mapAttrs (
      name: host:
        withSystem host.system (
          {...}:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {inherit inputs;};

              modules = let
                hostModuleName = "hosts/${name}";
                hostModule =
                  if config.flake.modules.nixos ? "hosts/${name}"
                  then config.flake.modules.nixos."hosts/${name}"
                  else throw "Host module `${hostModuleName}` is not defined.";
              in [
                {
                  imports =
                    builtins.map (
                      moduleName:
                        config.flake.modules.nixos.${moduleName}
                  or (throw "Unknown NixOS module `${moduleName}`.")
                    )
                    host.modules;
                }
                (
                  if host.useHomeManager
                  then {imports = [inputs.home-manager.nixosModules.home-manager];}
                  else {}
                )
                hostModule
              ];
            }
        )
    )
    config.hosts.nixos;
}
