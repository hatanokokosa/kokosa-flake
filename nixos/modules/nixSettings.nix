{
  inputs,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
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
    };
    overlays = [
      inputs.self.overlays.default
      inputs.nur.overlays.default
      (final: prev: {
        hid-bpf-uclogic = inputs.hid-bpf-uclogic.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];
  };

  # NixOS Helper
  programs.nh = {
    flake = "/home/hatano/Flake";
    enable = true;
    clean = {
      extraArgs = "--keep 5 --keep-since 7d";
      dates = "weekly";
      enable = true;
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
