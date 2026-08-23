{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive
    obs-studio
    v4l-utils
    openutau
    blender
    pureref
    splayer
    haruna
    subtitleedit
    krita
  ];
}
