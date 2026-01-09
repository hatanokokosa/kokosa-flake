# Kokosa Flake Utilities
#
# Shared utility functions for module discovery and file handling.
# Import this file directly: `import ../lib { inherit lib; }`
{lib ? import <nixpkgs/lib>}: rec {
  # stripNixExt :: String -> String
  # Removes the `.nix` extension from a filename.
  #
  # Example:
  #   stripNixExt "boot.nix" => "boot"
  #   stripNixExt "desktop"  => "desktop"
  stripNixExt = file: let
    m = builtins.match "^(.*)\\.nix$" file;
  in
    if m == null
    then file
    else builtins.head m;

  # discoverModules :: Path -> AttrSet
  # Discovers modules in a directory by convention:
  #   - `.nix` files (excluding default.nix) => modules
  #   - Subdirectories with `default.nix`    => modules
  #
  # Returns: { moduleName = <imported module>; ... }
  #
  # Example:
  #   discoverModules ./modules => { boot = <fn>; desktop = <fn>; ... }
  discoverModules = dir: let
    entries = builtins.readDir dir;
    names = builtins.attrNames entries;

    nixFiles =
      builtins.filter (
        f: builtins.match ".*\\.nix" f != null && f != "default.nix"
      )
      names;

    subDirs =
      builtins.filter (
        name:
          entries.${name}
          == "directory"
          && builtins.pathExists "${dir}/${name}/default.nix"
      )
      names;
  in
    builtins.listToAttrs (
      (map (file: {
          name = stripNixExt file;
          value = import "${dir}/${file}";
        })
        nixFiles)
      ++ (map (subdir: {
          name = subdir;
          value = import "${dir}/${subdir}";
        })
        subDirs)
    );

  # importAll :: Path -> [Path]
  # Returns paths to all `.nix` files in a directory.
  # Useful for Home Manager imports.
  #
  # Example:
  #   importAll ./modules => [ ./modules/fish.nix ./modules/fzf.nix ... ]
  importAll = dir:
    map (f: "${dir}/${f}")
    (builtins.filter (f: builtins.match ".*\\.nix" f != null)
      (builtins.attrNames (builtins.readDir dir)));

  # discoverHosts :: Path -> AttrSet
  # Discovers host modules from nixos/hosts/ directory.
  # Each host is named "hosts/<hostname>".
  #
  # Example:
  #   discoverHosts ./nixos/hosts => { "hosts/kokosa" = <fn>; ... }
  discoverHosts = hostsDir: let
    entries = builtins.readDir hostsDir;
    hostNames = builtins.filter (
      name:
        entries.${name}
        == "directory"
        && builtins.pathExists "${hostsDir}/${name}/default.nix"
    ) (builtins.attrNames entries);
  in
    builtins.listToAttrs (map (name: {
        name = "hosts/${name}";
        value = import "${hostsDir}/${name}/default.nix";
      })
      hostNames);
}
