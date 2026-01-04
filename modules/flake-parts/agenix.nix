{inputs, ...}: {
  imports = [inputs.agenix-rekey.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    # Add agenix-rekey command to devshell
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = [config.agenix-rekey.package];
    };
  };
}
