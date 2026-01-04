{pkgs, ...}: {
  programs.nix-index.enable = false;
  programs.appimage.binfmt = true;

  # Steam
  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Game Dev
    gdtoolkit_4
    godot

    # Gaming
    nur.repos.chillcicada.et-astral
    wineWow64Packages.full
    winePackages.fonts
    prismlauncher
    protonplus
    winetricks
    wineasio
    mangohud
    corectrl
    scanmem
    bottles
    clinfo
    vkd3d
    dxvk
  ];
}
