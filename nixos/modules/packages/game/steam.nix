{pkgs, ...}: {
  # Steam
  programs = {
    gamemode.enable = true;
    steam = {
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    corectrl
  ];
}
