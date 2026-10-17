{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    bitwarden-desktop
    joplin-desktop
    brave-origin
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
