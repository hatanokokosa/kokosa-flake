{inputs, ...}: {
  # enable flake-parts module
  imports = [inputs.flake-parts.flakeModules.modules];
  debug = false;
}
