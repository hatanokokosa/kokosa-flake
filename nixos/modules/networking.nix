{pkgs, ...}: {
  # Network Manager
  networking = {
    networkmanager.enable = true;
    firewall = {
      trustedInterfaces = ["mihomo" "tun0"];
      allowedUDPPorts = [21027 22000 11010 7890];
      allowedTCPPorts = [8384 22000 11010 7890];
      enable = false;
    };
  };

  # Clash GUI
  programs.clash-verge = {
    serviceMode = true;
    autoStart = true;
    tunMode = true;
    enable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.ip_forward" = 1;
  };
}
