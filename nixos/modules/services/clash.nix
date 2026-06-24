{pkgs, ...}: {
  programs.clash-verge = {
    package = pkgs.clash-nyanpasu;
    serviceMode = true;
    tunMode = true;
    enable = true;
  };
}
