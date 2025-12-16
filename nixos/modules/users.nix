{pkgs, ...}: {
  # Hatano
  users.users.hatano = {
    home = "/home/hatano";
    isNormalUser = true;
    shell = pkgs.fish;
    group = "users";
    extraGroups = [
      "networkmanager"
      "libvirtd"
      "kvm"
    ];
    packages = [pkgs.papirus-icon-theme];
  };

  # Shell & Alias
  programs.fish.enable = true;
  environment.shellAliases = {
    q = "exit";
    c = "clear";
    ls = "lsd";
    ll = "lsd -l";
    la = "lsd -la";
    lt = "lsd --tree";
    vim = "nvim";
    g = "rg";
    f = "fd";
    ff = "fastfetch";
    rm = "rip";
    cat = "bat";
    dig = "dog";
    disk = "duf";
    usage = "dust";
    huion = "doas hid-bpf-uclogic --device /sys/devices/pci0000:00/0000:00:14.0/usb1/1-6 --force --wait";
    zh = "set -gx LANG zh_CN.UTF-8";
  };

  # Zoxide
  programs.zoxide = {
    enableFishIntegration = true;
    enableBashIntegration = true;
    enable = true;
  };

  # Default Editor
  environment.variables.EDITOR = "nvim";
}
