# Configuration Guide

The flake auto-discovers modules; you mostly drop files in the right folder and list them for the host.

## Structure Overview

```
lib/
└── default.nix          # Shared utility functions
modules/
├── flake-parts/         # Flake-level modules (overlays, packages, etc.)
├── hosts/
│   ├── default.nix      # Host options schema
│   └── <host>.nix       # Per-host configuration (system, modules list)
├── nixos/
│   └── default.nix      # Auto-discovers NixOS modules
└── systems/
    └── default.nix      # Supported system architectures
nixos/
├── hosts/<host>/        # Host-specific hardware & settings
└── modules/             # Shared NixOS modules (auto-discovered)
home/
├── modules/             # Home Manager modules (auto-imported)
└── dotfiles/            # Dotfile sources
```

## Shared Library (`lib/default.nix`)

Available functions (import via `import "${inputs.self}/lib" {}`):

| Function | Type | Description |
|----------|------|-------------|
| `stripNixExt` | `String -> String` | Remove `.nix` extension |
| `discoverModules` | `Path -> AttrSet` | Discover modules in directory |
| `importAll` | `Path -> [Path]` | List all `.nix` paths in directory |
| `discoverHosts` | `Path -> AttrSet` | Discover host modules |

## NixOS Modules (system-level)

- Location: `nixos/modules/*.nix` (auto-registered by `modules/nixos/default.nix`).
- Use: reference the module name in `modules/hosts/<host>.nix` under `hosts.nixos.<host>.modules = [ "name" ... ];`.
- Template:
```nix
{ lib, ... }: {
  # services.<service>.enable = lib.mkDefault true;
}
```

## Host Configuration

- **Options schema**: `modules/hosts/default.nix`
- **Per-host config**: `modules/hosts/<host>.nix`
- **Host-specific hardware**: `nixos/hosts/<host>/default.nix`

Template for new host (`modules/hosts/<host>.nix`):
```nix
{...}: {
  config.hosts.nixos.<host> = {
    system = "x86_64-linux";
    useHomeManager = true;
    modules = [
      "boot"
      "desktop"
      # ...
    ];
  };
}
```

Then add `imports = [ ./<host>.nix ];` in `modules/hosts/default.nix`.

## Home Manager Modules

- Location: `home/modules/*.nix` (auto-imported by `nixos/modules/home.nix`).
- Enable: set `my.hm.<name>.enable = true;` in `nixos/modules/home.nix` under `home-manager.users.hatano.my.hm`.
- Reminder: flake evaluation sees the Git tree; keep new modules/dotfiles tracked or Nix won't find the options.
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

## Commands

- Format & Check: `just ci`
- Rebuild current boot: `just switch`
- Rebuild next boot: `just boot`
