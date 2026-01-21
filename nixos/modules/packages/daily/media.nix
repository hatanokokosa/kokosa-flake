{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Media
    kdePackages.kdenlive
    obs-studio
    v4l-utils
    openutau
    pureref
    splayer
    haruna
    krita
  ];
}
