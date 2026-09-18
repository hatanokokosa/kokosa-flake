{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    z-library-desktop
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
