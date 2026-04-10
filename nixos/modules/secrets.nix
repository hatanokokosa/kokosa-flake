{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets.syncthing-gui-password.file = inputs.self + "/secrets/syncthing-gui-password.age";
}
