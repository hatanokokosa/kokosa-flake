set shell := ["fish", "-c"]

# List available recipes
default:
  @just --list

# Format Nix code (Alejandra)
fmt:
  nix fmt .

# Show flake outputs
show:
  nix flake show

# Evaluate flake
check:
  nix flake check

# Format & Check
ci:
  just fmt
  just check

# Rebuild & Switch
switch:
  nh os switch .

# Rebuild & Next Boot
boot:
  nh os boot .

# Clean Garbage
clean:
  nh clean all

# Update Flake
update:
  nix flake update

# Start Repl
repl:
  nix repl --file flake.nix

# Debug Build
debug:
  nixos-rebuild build --flake .#kokosa --show-trace --verbose

# Edit Secret (usage: just secret-edit <path>)
secret-edit path:
  nix run github:ryantm/agenix -- -e {{path}}

# Rekey Secrets
secret-rekey:
  nix run github:oddlama/agenix-rekey -- rekey
