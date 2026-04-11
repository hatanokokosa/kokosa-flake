{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
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
