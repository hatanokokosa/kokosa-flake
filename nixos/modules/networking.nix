{...}: {
  # Network Manager
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = false;
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.ip_forward" = 1;
  };
}
