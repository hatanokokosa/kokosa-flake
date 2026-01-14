{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Media
    kdePackages.kdenlive
    obs-studio
    openutau
    pureref
    splayer
    haruna
    krita
  ];
}
