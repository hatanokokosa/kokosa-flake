{
  config,
  inputs,
  lib,
  ...
}: let
  rekeyedSecretsDir = inputs.self + "/secrets/rekeyed/${config.networking.hostName}";
  rekeyedSecretNames =
    if builtins.pathExists rekeyedSecretsDir
    then builtins.attrNames (builtins.readDir rekeyedSecretsDir)
    else [];
  syncthingGuiPasswordFile = let
    matches =
      builtins.filter (
        file: builtins.match ".*-syncthing-gui-password\\.age" file != null
      )
      rekeyedSecretNames;
  in
    if matches == []
    then null
    else rekeyedSecretsDir + "/${builtins.head matches}";
in {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  assertions = [
    {
      assertion = syncthingGuiPasswordFile != null;
      message = ''
        Missing rekeyed Syncthing GUI password for `${config.networking.hostName}`.
        Run `agenix rekey -a` and commit the generated file under `secrets/rekeyed/${config.networking.hostName}`.
      '';
    }
  ];

  age.rekey = {
    # Host SSH public key (obtained via ssh-keyscan localhost)
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgl+EIk/QAxExeVE5hAkhTXLwPQtv2dXYpBZFoGVeSB";

    # Path to the master identity used for decryption
    masterIdentities = ["/home/hatano/.config/agenix/master-key.txt"];

    # Use local storage mode (stores rekeyed secrets in your repository)
    storageMode = "local";
    localStorageDir = rekeyedSecretsDir;
  };

  age.secrets = lib.optionalAttrs (syncthingGuiPasswordFile != null) {
    syncthing-gui-password.file = syncthingGuiPasswordFile;
  };
}
