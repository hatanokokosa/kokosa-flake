{inputs, ...}: let
  homeModules = "${inputs.self}/home/modules";
  homeFiles = "${inputs.self}/home/dotfiles";

  # Auto Import Modules
  importModules = dir:
    builtins.map (f: "${dir}/${f}")
    (builtins.filter (f: builtins.match ".*\\.nix" f != null)
      (builtins.attrNames (builtins.readDir dir)));
in {
  # Home Manager
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit homeFiles;
    };

    # User Settings
    users.hatano = {
      home.stateVersion = "25.05";
      imports = importModules homeModules;

      # Enabled Modules
      my.hm = {
        fzf.enable = true;
        gh.enable = true;
        fish.enable = true;
      };
    };
  };
}
