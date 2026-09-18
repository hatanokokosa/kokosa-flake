{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    bitwarden-desktop
    bitwarden-cli
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
