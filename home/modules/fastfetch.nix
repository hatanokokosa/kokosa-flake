{
  config,
  lib,
  homeFiles,
  ...
}: let
  cfg = config.my.hm.fastfetch;
  dotdir = "${homeFiles}/fastfetch";
in {
  options.my.hm.fastfetch = {
    enable = lib.mkEnableOption "Manage fastfetch dotfiles";
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."fastfetch/config.jsonc".source = "${dotdir}/config.jsonc";
    xdg.configFile."fastfetch/kokosa.png".source = "${dotdir}/kokosa.png";
  };
}
