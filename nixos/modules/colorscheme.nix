{inputs, ...}: {
  imports = [inputs.catppuccin.nixosModules.catppuccin];

  catppuccin = {
    accent = "rosewater";
    flavor = "latte";
    enable = true;
  };
}
