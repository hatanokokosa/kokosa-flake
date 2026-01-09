{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Media
    kdePackages.kdenlive
    obs-studio
    openutau
    splayer
    haruna
    krita
  ];
}
