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
