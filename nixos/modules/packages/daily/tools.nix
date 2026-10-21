{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    joplin-desktop
    brave-origin
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
