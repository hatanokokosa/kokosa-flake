{
  description = "Kokosa's Nix Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other
    hid-bpf-uclogic = {
      url = "github:dramforever/hid-bpf-uclogic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    flake = inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
  in
    # Drop non-standard outputs to avoid `nix flake check` warnings.
    builtins.removeAttrs flake ["modules" "debug" "allSystems"];
}
