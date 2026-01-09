{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Tools
    kdePackages.partitionmanager
    handbrake
    obsidian
    upscayl
    firefox
  ];
}
