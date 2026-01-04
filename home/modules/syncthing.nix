{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.my.hm.syncthing;
in {
  options.my.hm.syncthing.enable = lib.mkEnableOption "Syncthing";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      extraOptions = {
        gui = {
          user = "kokosa";
          passwordFile = osConfig.age.secrets.syncthing-gui-password.path;
        };
      };
    };
  };
}
