{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nur.repos.rewine.ttf-wps-fonts
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      source-han-serif
      source-han-sans
      sarasa-gothic
      kokosa-mono
      noto-fonts
      fraunces
    ];
    fontconfig = {
      localConf = builtins.readFile ./config/fontconfig.conf;
      subpixel.rgba = "rgb";
      cache32Bit = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Kokosa Mono"
          "Sarasa Mono SC"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Source Han Sans SC"
          "Noto Color Emoji"
        ];
        serif = [
          "Source Han Serif SC"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
