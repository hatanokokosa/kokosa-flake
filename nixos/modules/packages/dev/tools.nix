{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Dev Tools
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
