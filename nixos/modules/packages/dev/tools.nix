{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bubblewrap
    distrobox
    lazygit
    jujutsu
    direnv
    kitty
    just
    omp
    dsh
    git
    gcc
  ];
}
