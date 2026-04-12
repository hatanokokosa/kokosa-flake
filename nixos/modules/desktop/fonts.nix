{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nur.repos.rewine.ttf-wps-fonts
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      kokosa-mono
      noto-fonts
    ];

    # font config
    fontconfig = {
      localConf = builtins.readFile ./config/fontconfig.conf;
      subpixel.rgba = "rgb";
      cache32Bit = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Kokosa Mono"
          "FZSJ-ZHUZAYTB"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
