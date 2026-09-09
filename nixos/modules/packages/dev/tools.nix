{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bubblewrap
    distrobox
    chatgpt
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
