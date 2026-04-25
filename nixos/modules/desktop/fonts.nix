{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nur.repos.rewine.ttf-wps-fonts
      nerd-fonts.symbols-only
      source-han-serif-vf-otf
      source-han-sans-vf-otf
      noto-fonts-color-emoji
      kokosa-mono
      noto-fonts
      fraunces
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
          "Source Han Sans SC VF"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Source Han Sans SC VF"
          "Noto Color Emoji"
        ];
        serif = [
          "Source Han Serif SC VF"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
