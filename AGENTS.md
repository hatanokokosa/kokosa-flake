# AGENTS.md

## Operating Rules

- Read `GUIDE.md` & `CONVENTIONS.md` before changing repository architecture, module wiring, or secrets. It is the canonical project reference.
- Scope changes first. Inspect existing modules, inputs, and package exports before adding or replacing configuration.
- Preserve local patterns and keep changes minimal; do not introduce parallel configuration paths.
- Inspect package names from pinned flake inputs with `nix flake show` or `nix eval` before referencing them.
- Do not run `just switch`, `just boot`, or `just update` unless explicitly requested.
- Only delete paths with `rip`; never use `rm`, including `rm -rf`.
- Never edit encrypted secret files directly. Use `just secret-edit <path>`.
- Add new modules, dotfiles, package sources, and secret files to Git before relying on flake evaluation.

## Nix Workflow

- Format Nix changes with `just fmt` (`nix fmt .` via Alejandra).
- Use `just check` for flake evaluation.
- Use `just ci` as the standard verification path: format, then evaluate.
- Use `just show` to inspect flake outputs.

## Change Completion

- For configuration changes, evaluate the affected NixOS or flake output after editing.
- Confirm package-list changes through the evaluated configuration, not source inspection alone.
- Update `GUIDE.md` only when the repository’s architecture or maintenance procedure changes.
