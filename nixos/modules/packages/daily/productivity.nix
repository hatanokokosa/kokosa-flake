{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Productivity
    kdePackages.partitionmanager
    anki-bin
    obsidian
    firefox
  ];
}
