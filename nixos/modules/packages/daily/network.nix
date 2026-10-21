{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    rayburst
  ];
}
