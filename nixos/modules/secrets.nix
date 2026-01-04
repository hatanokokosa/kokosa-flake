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
    # Obtain this using `ssh-keyscan localhost` or by looking it up in ~/.ssh/known_hosts
    # You need to replace this with your actual host's SSH public key
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA_REPLACE_WITH_YOUR_HOST_PUBKEY";

    # Path to the master identity used for decryption
    # Options:
    #   - YubiKey: ./secrets/yubikey-identity.pub
    #   - FIDO2: ./secrets/fido2-identity.pub
    #   - Age key: /path/to/master-key (or age file)
    masterIdentities = [./master-key.pub];

    # Use local storage mode (stores rekeyed secrets in your repository)
    storageMode = "local";
    localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
  };

  # Example secret definition (for Syncthing password)
  # You need to create this file with: agenix edit secrets/syncthing-password.age
  # age.secrets.syncthing-password = {
  #   rekeyFile = ./secrets/syncthing-password.age;
  #   owner = "hatano";
  #   group = "users";
  # };
}
