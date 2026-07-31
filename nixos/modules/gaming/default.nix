{...}: {
  imports = [
    ./appimage.nix
    ../packages/game/gamedev.nix
    ../packages/game/steam.nix
    ../packages/game/wine.nix
  ];
}
