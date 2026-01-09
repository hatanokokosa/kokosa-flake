{...}: {
  programs.nh = {
    flake = "/home/hatano/Flake";
    enable = true;
    clean = {
      extraArgs = "--keep 5 --keep-since 7d";
      dates = "weekly";
      enable = true;
    };
  };
}
