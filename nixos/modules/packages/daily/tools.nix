{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    joplin-desktop
    brave-origin
    chromium
    obsidian
    upscayl
    firefox
  ];
}
