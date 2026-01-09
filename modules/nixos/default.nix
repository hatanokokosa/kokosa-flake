{inputs, ...}: let
  sharedDir = "${inputs.self}/nixos/modules";
  hostsDir = "${inputs.self}/nixos/hosts";

  stripNixExt = file: let
    m = builtins.match "^(.*)\\.nix$" file;
  in
    if m == null
    then file
    else builtins.head m;

  dirEntries = builtins.readDir sharedDir;

  # .nix files (excluding default.nix)
  nixFiles =
    builtins.filter (f: builtins.match ".*\\.nix" f != null && f != "default.nix")
    (builtins.attrNames dirEntries);

  # Directories containing default.nix
  subDirs = builtins.filter (
    name:
      dirEntries.${name}
      == "directory"
      && builtins.pathExists "${sharedDir}/${name}/default.nix"
  ) (builtins.attrNames dirEntries);

  sharedModules = builtins.listToAttrs (
    (map (file: {
        name = stripNixExt file;
        value = import "${sharedDir}/${file}";
      })
      nixFiles)
    ++ (map (dir: {
        name = dir;
        value = import "${sharedDir}/${dir}";
      })
      subDirs)
  );

  hostModules = let
    hostEntries = builtins.readDir hostsDir;
    hostNames =
      builtins.filter
      (
        name: let
          entryType = hostEntries.${name};
        in
          entryType == "directory" && builtins.pathExists "${hostsDir}/${name}/default.nix"
      )
      (builtins.attrNames hostEntries);
  in
    builtins.listToAttrs
    (map
      (name: {
        name = "hosts/${name}";
        value = import "${hostsDir}/${name}/default.nix";
      })
      hostNames);
in {
  flake.modules.nixos = sharedModules // hostModules;
}
