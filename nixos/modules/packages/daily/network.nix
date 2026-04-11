{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    motrix-next
  ];
}
