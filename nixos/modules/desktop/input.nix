{pkgs, ...}: {
  # Rime dotfiles are managed by home/modules/rime.nix
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        qt6Packages.fcitx5-configtool
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
        fcitx5-fluent
        (fcitx5-rime.override {
          rimeDataPkgs = [
            pkgs.rime-wanxiang
          ];
        })
      ];
    };
  };
}
