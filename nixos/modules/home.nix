# Uses lib/default.nix to import user modules
{inputs, ...}: let
  utils = import "${inputs.self}/lib";
  homeModules = "${inputs.self}/home/modules";
  homeFiles = "${inputs.self}/home/dotfiles";
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    backupFileExtension = "hm-bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit (inputs) catppuccin;
      inherit homeFiles;
    };

    users.hatano = {
      home.stateVersion = "25.05";
      imports =
        utils.importAll homeModules
        ++ [inputs.catppuccin.homeModules.catppuccin];

      catppuccin = {
        accent = "rosewater";
        flavor = "latte";
        enable = true;
      };

      my.hm = {
        fastfetch.enable = true;
        rmpc.enable = true;
        rime.enable = true;
        fish.enable = true;
        fzf.enable = true;
        mpd.enable = true;
        gh.enable = true;
      };
    };
  };
}
