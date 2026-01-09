{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Network Tools
    qbittorrent-enhanced
    v2raya
    motrix
  ];
}
