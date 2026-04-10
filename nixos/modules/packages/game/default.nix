{...}: {
  programs.appimage.binfmt = true;

  imports = [
    ./gamedev.nix
    ./steam.nix
    ./wine.nix
  ];
}
