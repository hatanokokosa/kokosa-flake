{...}: {
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
    zh = "set -gx LANG zh_CN.UTF-8";
  };

  programs.zoxide = {
    enableFishIntegration = true;
    enableBashIntegration = true;
    enable = true;
  };
}
