{inputs, ...}: {
  imports = [
    ./nh.nix
    ./nix-ld.nix
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
        "https://nix-community.cachix.org"
        "https://codex-cli.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspc9LCsg="
      ];
      http-connections = 20;
      connect-timeout = 10;
      fallback = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [inputs.self.overlays.all];
  };
}
