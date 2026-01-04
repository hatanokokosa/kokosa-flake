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
      passwordFile = osConfig.age.secrets.syncthing-gui-password.path;
      extraOptions = [
        "--gui-address=127.0.0.1:8384"
      ];
      settings = {
        gui = {
          user = "kokosa";
        };
      };
    };
  };
}
