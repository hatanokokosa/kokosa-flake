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
    backupFileExtension = "hm-bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit (inputs) catppuccin;
      inherit homeFiles;
    };

    # User Settings
    users.hatano = {
      home.stateVersion = "25.05";
      imports =
        importModules homeModules
        ++ [
          inputs.catppuccin.homeModules.catppuccin
        ];

      # Colorscheme
      catppuccin = {
        accent = "rosewater";
        flavor = "latte";
        enable = true;
      };

      # Enabled Modules
      my.hm = {
        fastfetch.enable = true;
        rime.enable = true;
        fish.enable = true;
        fzf.enable = true;
        gh.enable = true;
        syncthing.enable = true;
      };
    };
  };
}
