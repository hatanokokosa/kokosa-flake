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
    nix flake check

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
