{inputs, ...}: {
  # Enable flake-parts module support for `flake.modules`.
  imports = [inputs.flake-parts.flakeModules.modules];

  debug = true;
}
