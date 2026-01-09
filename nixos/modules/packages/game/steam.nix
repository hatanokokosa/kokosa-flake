{pkgs, ...}: {
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
    mangohud
    corectrl
  ];
}
