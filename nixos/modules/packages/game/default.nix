{...}: {
  programs.nix-index.enable = false;
  programs.appimage.binfmt = true;

  imports = [
    ./gamedev.nix
    ./steam.nix
    ./wine.nix
  ];
}
