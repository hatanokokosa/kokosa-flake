{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    paseo-desktop
    bubblewrap
    distrobox
    lazygit
    jujutsu
    direnv
    kitty
    paseo
    just
    omp
    git
    gcc
  ];
}
