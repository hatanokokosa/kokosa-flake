# Configuration Guide

The flake auto-discovers modules.

## Structure Overview

```
lib/
└── default.nix                 # Module discovery and import helpers
modules/
├── flake-parts/                # Flake-level outputs and overlays
└── systems/                    # Supported system architectures
nixos/
├── hosts/<host>/               # Hardware facts and final host policy
├── modules/
│   ├── boot/                   # Bootloader, kernel, and memory capabilities
│   ├── core/                   # Locale, user, and security capabilities
│   ├── desktop/                # Plasma, audio, input, fonts, and theme
│   ├── hardware/               # GPU, Bluetooth, and peripheral capabilities
│   ├── network/                # NetworkManager, firewall, SSH, and proxy
│   └── ...                     # Gaming, media, packages, power, etc.
└── profiles/                   # Orthogonal policy compositions
home/
├── modules/                    # Individual Home Manager capabilities
├── profiles/                   # Home Manager policy compositions
└── dotfiles/                   # Dotfile sources
```

## Architecture Flow

```text
nixos/hosts/kokosa
├─ nixosProfiles.base
├─ nixosProfiles.graphical
├─ nixosProfiles.development
├─ nixosProfiles.gaming
├─ nixosProfiles.creator
├─ nixosProfiles.virtualisation
├─ other orthogonal profiles
├─ hardware-specific modules
└─ hardware.nix
```

A leaf module is a small configuration fragment that uses upstream NixOS
options directly. Importing the module enables that fragment. Profiles compose
related fragments with `imports`; hosts select profiles, add hardware-specific
modules, and make final policy overrides. Profiles never contain filesystem
UUIDs or generated hardware configuration.

## Shared Library (`lib/default.nix`)

Available functions (import via `import "${inputs.self}/lib"`):

| Function | Type | Description |
|----------|------|-------------|
| `stripNixExt` | `String -> String` | Remove `.nix` extension |
| `discoverModules` | `Path -> AttrSet` | Discover `.nix` files and subdirectories with `default.nix` |
| `importAll` | `Path -> [Path]` | List non-default `.nix` paths in one directory |

## NixOS Modules (system-level)

- Configuration fragments live under `nixos/modules/`.
- Category `default.nix` files aggregate related fragments.
- Profiles import only the fragments they need; importing a fragment is its
  enable switch.
- Use upstream NixOS options directly instead of adding one-to-one wrappers.
- Top-level modules are auto-exported as `nixosModules.<name>` by `flake.nix`.
- Define custom options only for modules that provide real parameterization or
  invariants beyond an upstream option.

## Nix Binary Caches

- `nixos/modules/nix/caches.nix` defines direct mirrors and trusted keys.
- `nixos/modules/nix/s4nix.nix` provides the optional selector4nix service;
  use `http://127.0.0.1:5496/` to view progress when enabled.

## Host Configuration

- **Flake registration**: `flake.nix`
- **Host composition**: `nixos/hosts/<host>/default.nix`
- **Generated hardware facts**: `nixos/hosts/<host>/hardware.nix`

Template for a host entry:
```nix
{
  nixosProfiles,
  ...
}: {
  imports = [
    nixosProfiles.base
    nixosProfiles.graphical
    ../../modules/hardware/amd-gpu.nix
    ./hardware.nix
  ];

  networking = {
    hostName = "<host>";
    firewall.enable = false;
  };
  system.stateVersion = "24.11";
}
```

Then register it in `flake.nix`.

Example:
```nix
nixosConfigurations.<host> = inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs nixosModules nixosProfiles;
  };
  modules = [ ./nixos/hosts/<host> ];
};
```

## Home Manager Modules

- Capability modules live under `home/modules/`; their `my.hm.*` options are
  retained because they manage real program configuration and dotfiles.
- Policy fragments live under `home/profiles/` and set those options directly.
- `nixos/modules/home.nix` provides the shared Home Manager integration.
- NixOS profiles append the matching Home Manager profile to
  `home-manager.users.hatano.imports`.
- Keep new modules and dotfiles tracked; flake evaluation only sees the Git tree.
- Basic template:
```nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.<name>;
in {
  options.my.hm.<name> = {
    enable = lib.mkEnableOption "Enable <name> via Home Manager";
    # ...
  };
  config = lib.mkIf cfg.enable {
    programs.<name> = {
      enable = true;
      # ...
    }
  };
}
```

### Home Manager Modules Linking Dotfiles

- Dotfiles: place under `home/dotfiles/<name>/...`.
- Module template:
```nix
{
  config,
  lib,
  homeFiles,
  ...
}: let
  cfg = config.my.hm.<name>;
  dotdir = "${homeFiles}/<name>";
in {
  options.my.hm.<name> = {
    enable = lib.mkEnableOption "Manage <name> dotfiles";
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."<name>/<file or dir>".source = "${dotdir}/<file or dir>";
  };
}
```

## Secrets

- Source secrets live under `secrets/*.age`.
- `secrets.nix` declares which public keys can edit each source secret.
- `nixos/modules/secrets.nix` maps a NixOS secret name to its encrypted source file.
- Reminder: if a new secret file is not tracked by Git, Flake evaluation will not see it.

### Secret Wiring Pattern

Declare the secret in `nixos/modules/secrets.nix`:
```nix
{
  inputs,
  ...
}: {
  age.secrets.<name> = {
    file = inputs.self + "/secrets/<name>.age";
    owner = "<user>";
  };
}
```

Consume the decrypted file from another module via `config.age.secrets.<name>.path`:
```nix
{ config, ... }: {
  services.<service> = {
    # The service reads the decrypted plaintext file from /run/agenix/...
    passwordFile = config.age.secrets.<name>.path;
  };
}
```

### Add Or Rotate A Password

1. Add an entry in `secrets.nix` for `secrets/<name>.age`.
2. Wire it into `nixos/modules/secrets.nix` with `age.secrets.<name>.file = inputs.self + "/secrets/<name>.age";`.
3. Create or edit the source secret:
   `just secret-edit secrets/<name>.age`
   Put the plaintext password in the file and save.
4. Commit the source secret and the Nix changes.

## Commands

- Format & Check: `just ci`
- Rebuild current boot: `just switch`
- Rebuild next boot: `just boot`
