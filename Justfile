set shell := ["fish", "-c"]

# list available recipes
default:
    @just --list

add:
    git add -A

# format via alejandra
fmt:
    nix fmt .

# show flake outputs
show:
    nix flake show

# evaluate flake
check:
    nix flake check --no-build

# format & check
ci:
    just fmt
    just check

# rebuild & switch
switch:
    nh os switch .

# rebuild & next boot
boot:
    nh os boot .

# deploy to a remote host - usage: just deploy <host> root@<ip>
deploy host target:
    nixos-rebuild switch --flake .#{{ host }} --target-host {{ target }}

# clean garbage
clean:
    nh clean all

# update flake
update:
    nix flake update

# start repl
repl:
    nix repl --file flake.nix

# edit secret - usage: just secret-edit secrets/<name>.age
secret-edit path:
    nix run .#vaultix.app.x86_64-linux.edit -- {{ path }}

# re-encrypt secrets for the hosts in flake.vaultix.nodes - run after adding, editing or removing one
secret-renc:
    nix run .#vaultix.app.x86_64-linux.renc

# install nixos on a remote host - usage: ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<ip> && just install <host> root@<ip>
install host target:
    nix run --inputs-from . nixpkgs#nixos-anywhere -- --flake .#{{ host }} --target-host {{ target }} -i ~/.ssh/id_ed25519 --build-on local --ssh-option ServerAliveInterval=15 --ssh-option ServerAliveCountMax=8 --generate-hardware-config nixos-generate-config ./nixos/hosts/{{ host }}/hardware.nix

# test a host's disk layout and boot in a vm - usage: just vm-test <host>
vm-test host:
    nix run --inputs-from . nixpkgs#nixos-anywhere -- --flake .#{{ host }} --vm-test
