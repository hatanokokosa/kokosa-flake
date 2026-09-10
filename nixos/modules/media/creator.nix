{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive
    splayer-next
    obs-studio
    v4l-utils
    openutau
    blender
    pureref
    haruna
    krita
  ];
}
