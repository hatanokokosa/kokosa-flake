{
  description = "Kokosa's Nix Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake Parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    # Secrets Management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    flake = inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
    nixosModules = (import ./lib).discoverModules ./nixos/modules;
    nixosConfigurations = {
      kokosa = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs nixosModules;
        };
        modules = [./nixos/hosts/kokosa];
      };
    };
  in
    # Drop non-standard outputs to avoid `nix flake check` warnings.
    (removeAttrs flake ["modules" "debug" "allSystems"])
    // {inherit nixosConfigurations;};
}
