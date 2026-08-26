{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bubblewrap
    distrobox
    lazygit
    jujutsu
    chatgpt
    direnv
    kitty
    just
    omp
    dsh
    git
    gcc
  ];
}
