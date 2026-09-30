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

# clean garbage
clean:
    nh clean all

# update flake
update:
    nix flake update

# start repl
repl:
    nix repl --file flake.nix

# edit secret - usage: just secret-edit <path>
secret-edit path:
    nix run github:ryantm/agenix -- -i /home/hatano/.config/agenix/master-key.txt -e {{ path }}

# install nixos on a remote host - usage: ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<ip> && just install <host> root@<ip>
install host target:
    nix run --inputs-from . nixpkgs#nixos-anywhere -- --flake .#{{ host }} --target-host {{ target }} -i ~/.ssh/id_ed25519 --build-on local --ssh-option ServerAliveInterval=15 --ssh-option ServerAliveCountMax=8 --generate-hardware-config nixos-generate-config ./nixos/hosts/{{ host }}/hardware.nix

# test a host's disk layout and boot in a vm - usage: just vm-test <host>
vm-test host:
    nix run --inputs-from . nixpkgs#nixos-anywhere -- --flake .#{{ host }} --vm-test
