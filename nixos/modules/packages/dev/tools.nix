{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Dev Tools
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
