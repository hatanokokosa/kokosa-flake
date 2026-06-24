{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    handbrake
    chromium
    obsidian
    upscayl
    firefox
  ];
}
