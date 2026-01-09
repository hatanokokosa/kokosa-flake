{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Network Tools
    qbittorrent-enhanced
    motrix
  ];
}
