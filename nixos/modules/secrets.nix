{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets.syncthing-gui-password = {
    file = inputs.self + "/secrets/syncthing-gui-password.age";
    owner = "hatano";
  };

  age.secrets.mihomo-subscription = {
    file = inputs.self + "/secrets/mihomo-subscription.age";
  };
}
