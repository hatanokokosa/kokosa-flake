{config, ...}: {
  programs.nh = {
    flake = "${config.users.users.hatano.home}/Flake";
    enable = true;
    clean = {
      extraArgs = "--keep 5 --keep-since 7d";
      dates = "weekly";
      enable = true;
    };
  };
}
