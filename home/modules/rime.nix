{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.rime;
  # librime searches the user data directory, not the merged fcitx5 addon tree.
  openccData =
    pkgs.runCommand "wanxiang-opencc-data" {
      nativeBuildInputs = [pkgs.opencc];
    } ''
      mkdir -p "$out"
      cp -r ${pkgs.rime-wanxiang}/share/rime-data/opencc/. "$out/"
      chmod -R u+w "$out"
      for dictionary in STCharacters STPhrases HKVariants TWVariants emoji; do
        opencc_dict -i "$out/wanxiang/$dictionary.txt" \
          -o "$out/wanxiang/$dictionary.ocd2" -f text -t ocd2
      done
    '';
in {
  options.my.hm.rime = {
    enable = lib.mkEnableOption "Manage Rime configuration for fcitx5";
  };

  config = lib.mkIf cfg.enable {
    home.activation.clearRimeCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
      rm -rf $HOME/.local/share/fcitx5/rime/build
    '';

    xdg.dataFile = {
      "fcitx5/rime/opencc".source = openccData;

      "fcitx5/rime/default.custom.yaml".text = ''
        patch:
          "__include": wanxiang_suggested_default:/
          schema_list:
            - schema: wanxiang
      '';

      "fcitx5/rime/wanxiang.custom.yaml".text = ''
        patch:
          speller/algebra:
            __patch:
              - wanxiang_algebra:/base/小鹤双拼
      '';
    };
  };
}
