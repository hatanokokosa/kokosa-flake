{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    handbrake
    obsidian
    upscayl
    firefox
  ];
}
