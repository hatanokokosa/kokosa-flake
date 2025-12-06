{
  inputs,
  pkgs,
  ...
}: let
  nurOverlay =
    if inputs.nur ? overlays && inputs.nur.overlays ? default
    then inputs.nur.overlays.default
    else inputs.nur.overlay;
in {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store?priority=10"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5C2h437HQ2C2A0bU5E="
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
      allowBroken = false;
    };
    overlays = [
      nurOverlay
      (final: prev: {
        hid-bpf-uclogic = inputs.hid-bpf-uclogic.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];
  };

  # NixOS Helper
  programs.nh = {
    enable = true;
    flake = "/home/hatano/Flake";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  # Nix-ld
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      icu
    ];
  };
}
