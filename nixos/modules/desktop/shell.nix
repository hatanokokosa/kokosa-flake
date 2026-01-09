{pkgs, ...}: {
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
    du = "duf";
    huion = "doas hid-bpf-uclogic --device /sys/devices/pci0000:00/0000:00:14.0/usb1/1-6 --force --wait";
    zh = "set -gx LANG zh_CN.UTF-8";
  };

  programs.zoxide = {
    enableFishIntegration = true;
    enableBashIntegration = true;
    enable = true;
  };
}
