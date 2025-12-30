{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.anki;
in {
  options.my.hm.anki = {
    enable = lib.mkEnableOption "Enable Anki with Catppuccin theme";
  };

  config = lib.mkIf cfg.enable {
    catppuccin.anki.enable = true;

    programs.anki = {
      package = pkgs.anki;
      enable = true;
    };
  };
}
