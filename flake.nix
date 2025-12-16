{
  description = "Kokosa's Nix Flake";

  inputs = {
    # Nixpkgs & NUR
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    # Flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other
    hid-bpf-uclogic.url = "github:dramforever/hid-bpf-uclogic";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs: let
    flake = inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
  in
    # Drop non-standard outputs to avoid `nix flake check` warnings.
    builtins.removeAttrs flake ["modules" "debug" "allSystems"];
}
