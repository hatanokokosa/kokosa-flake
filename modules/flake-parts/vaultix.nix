{inputs, ...}: {
  imports = [inputs.vaultix.flakeModules.default];

  flake.vaultix = {
    # renc encrypts for every node listed here, and each node must import the
    # vaultix nixos module, so list only the hosts that declare secrets.
    nodes = {inherit (inputs.self.nixosConfigurations) irisu;};
    identity = "/home/hatano/.config/agenix/master-key.txt";
  };
}
