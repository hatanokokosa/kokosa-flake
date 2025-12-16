# Configuration Guide

The flake auto-discovers modules; you mostly drop files in the right folder and list them for the host.

## NixOS Modules (system-level)
- Location: `nixos/modules/*.nix` (auto-registered by `modules/nixos/default.nix`).
- Use: reference the module name in `modules/hosts/default.nix` under `hosts.nixos.<host>.modules = [ "name" ... ];`.
- Template:
```nix
{ lib, ... }: {
  # services.<service>.enable = lib.mkDefault true;
}
```

## Host Modules (per-machine)
- Location: `nixos/hosts/<host>/default.nix` (auto-registered as `hosts/<host>`).
- Use: declared in `modules/hosts/default.nix` with system + module list; keep host-specific settings/hardware here.

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
    xdg.configFile."<name>/<file or dir>".source = "${dotdir}/<file or dir>";
  };
}

```

## Commands
- Format: `just fmt`
- Check: `just check`
- Rebuild current boot: `just switch` (`nh os switch .`; requires `nh`, else `sudo nixos-rebuild switch -L --flake .#kokosa`)
- Rebuild next boot: `just boot` (`nh os boot .`; requires `nh`, else `sudo nixos-rebuild boot -L --flake .#kokosa`)
