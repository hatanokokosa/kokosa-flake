{
  config,
  lib,
  ...
}: let
  cfg = config.my.hm.rime;
in {
  options.my.hm.rime = {
    enable = lib.mkEnableOption "Manage Rime configuration for fcitx5";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "fcitx5/rime/default.custom.yaml".text = ''
        patch:
          "__include": wanxiang_suggested_default:/
          schema_list:
            - schema: wanxiang
      '';

      "fcitx5/rime/wanxiang.custom.yaml".text = ''
        patch:
          "__include": wanxiang_algebra:/flypy
      '';
    };
  };
}
