{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bubblewrap
    distrobox
    boxbuddy
    lazygit
    jujutsu
    direnv
    kitty
    just
    git
    gcc
  ];
}
