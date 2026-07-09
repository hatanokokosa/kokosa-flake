# AGENTS.md

## Commands

- Use `just fmt` to format Nix files; it runs `nix fmt .` with the flake formatter (`alejandra`).
- Use `just check` to evaluate the flake with `nix flake check`.
- Use `just ci` for the normal verification path: format, then check.
- Use `just show` to inspect flake outputs.
- `just switch` runs `nh os switch .`; `just boot` runs `nh os boot .`.
- `just update` updates `flake.lock`.

## Architecture

- `flake.nix` builds the flake through `flake-parts` and registers one NixOS host: `kokosa` on `x86_64-linux`.
- Top-level NixOS modules are discovered from `nixos/modules` via `lib.discoverModules` and imported by `nixos/hosts/kokosa/default.nix` as `nixosModules.<name>`.
- `modules/flake-parts` defines flake outputs such as formatter, overlays, packages, and `legacyPackages`.
- Custom packages live under `pkgs`; the default overlay exposes `kokosa-mono`, and the combined overlay also adds NUR plus selected `llm-agents` packages.

## Module Conventions

- `lib.discoverModules` only discovers `.nix` files and subdirectories with `default.nix` directly under the target directory; it does not recursively discover nested files.
- Nested NixOS groups such as `nixos/modules/desktop`, `packages`, `services`, and `nix` are wired by their local `default.nix` import lists. Add new nested modules there.
- Home Manager modules under `home/modules/*.nix` are auto-imported, but new `my.hm.<name>` modules must also be enabled in `nixos/modules/home.nix` under `home-manager.users.hatano.my.hm`.
- Home Manager dotfile sources live under `home/dotfiles` and are passed to modules as `homeFiles`.

## Secrets And Git Gotchas

- Agenix secret access is declared in `secrets.nix`; runtime NixOS secret mappings are in `nixos/modules/secrets.nix`.
- Edit encrypted secrets with `just secret-edit <path>`.
- Flake evaluation uses `inputs.self`, so new modules, dotfiles, package sources, and secret files must be tracked by Git before Nix can see them reliably.
