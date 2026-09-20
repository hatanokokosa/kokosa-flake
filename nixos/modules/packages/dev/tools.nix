{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    paseo-desktop
    bubblewrap
    distrobox
    lazygit
    jujutsu
    direnv
    kitty
    just
    omp
    git
    gcc
  ];
}
