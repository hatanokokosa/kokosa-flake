{pkgs, ...}: {
  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
    };

    # Fcitx5 Input Method
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          qt6Packages.fcitx5-configtool
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
          fcitx5-fluent
        ];
      };
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nur.repos.rewine.ttf-wps-fonts
      nerd-fonts.symbols-only
      source-han-serif-vf-otf
      source-han-sans-vf-otf
      noto-fonts-color-emoji
      maple-mono.truetype
      dejavu_fonts
      noto-fonts

      (google-fonts.override {
        fonts = [
          "Space Grotesk"
        ];
      })
    ];

    # Font Config
    fontconfig = {
      localConf = builtins.readFile ./fonts/fontconfig.conf;
      subpixel.rgba = "rgb";
      cache32Bit = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Maple Mono CN"
          "FZSJ-ZHUZAYTB"
          "Symbols Nerd Font"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Source Han Sans SC VF"
          "Noto Color Emoji"
        ];
        serif = [
          "DejaVu Serif"
          "Source Han Serif SC VF"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
