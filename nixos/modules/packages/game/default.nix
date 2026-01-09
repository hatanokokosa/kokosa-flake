{...}: {
  programs.nix-index.enable = false;
  programs.appimage.binfmt = true;

  imports = [
    ./steam.nix
    ./wine.nix
    ./gamedev.nix
  ];
}
