{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  age.rekey = {
    # Host SSH public key (obtained via ssh-keyscan localhost)
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgl+EIk/QAxExeVE5hAkhTXLwPQtv2dXYpBZFoGVeSB";

    # Path to the master identity used for decryption
    masterIdentities = ["/home/hatano/.config/agenix/master-key.txt"];

    # Use local storage mode (stores rekeyed secrets in your repository)
    storageMode = "local";
    localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
  };
}
