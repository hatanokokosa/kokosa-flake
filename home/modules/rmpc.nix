{
  config,
  lib,
  pkgs,
  homeFiles,
  ...
}: let
  cfg = config.my.hm.rmpc;
  dotdir = "${homeFiles}/rmpc";
in {
  options.my.hm.rmpc = {
    enable = lib.mkEnableOption "Enable rmpc MPD client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.rmpc];

    xdg.configFile."rmpc/config.ron".source = "${dotdir}/config.ron";
    xdg.configFile."rmpc/themes".source = "${dotdir}/themes";
  };
}
