{
  description = "Kokosa's Nix Flake";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # flake parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # cachyos kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other
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
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    # main flake outputs. modules discovered from ./modules
    flake = inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

    # discover and collect NixOS modules under ./nixos/modules.
    nixosModules = (import ./lib).discoverModules ./nixos/modules;

    # define NixOS system configurations exposed by this flake
    nixosConfigurations = {
      # host configuration: kokosa
      kokosa = inputs.nixpkgs.lib.nixosSystem {
        modules = [./nixos/hosts/kokosa];
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs nixosModules;
        };
      };
    };
  in
    # avoid warnings from 'nix flake check'
    (removeAttrs flake ["modules" "debug" "allSystems"])
    // {
      # re-export it as flake outputs
      inherit nixosConfigurations nixosModules;
    };
}
