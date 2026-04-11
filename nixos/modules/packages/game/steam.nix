{pkgs, ...}: {
  programs = {
    gamemode.enable = true;
    steam = {
      fontPackages = with pkgs; [wqy_microhei noto-fonts-cjk-sans];
      extraCompatPackages = [pkgs.proton-ge-bin];
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    corectrl
  ];
}
