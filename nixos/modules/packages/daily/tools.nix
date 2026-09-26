{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    bitwarden-desktop
    joplin-desktop
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
