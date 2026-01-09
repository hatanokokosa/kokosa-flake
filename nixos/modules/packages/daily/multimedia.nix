{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Multimedia
    kdePackages.kdenlive
    obs-studio
    handbrake
    openutau
    upscayl
    splayer
    haruna
    krita
    rnote
  ];
}
