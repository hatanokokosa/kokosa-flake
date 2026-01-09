{pkgs, ...}: {
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
      kokosa-mono
      noto-fonts

      (google-fonts.override {
        fonts = [
          "Space Grotesk"
        ];
      })
    ];

    # Font Config
    fontconfig = {
      localConf = builtins.readFile ./config/fontconfig.conf;
      subpixel.rgba = "rgb";
      cache32Bit = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Kokosa Mono"
          "Maple Mono"
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
