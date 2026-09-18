{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    bitwarden-desktop
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
