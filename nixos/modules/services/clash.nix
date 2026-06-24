{pkgs, ...}: {
  programs.clash-verge = {
    package = pkgs.clash-nyanpasu;
    serviceMode = true;
    autoStart = true;
    tunMode = true;
    enable = true;
  };
}
