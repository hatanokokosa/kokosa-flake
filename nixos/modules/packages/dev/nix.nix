{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Nix
    alejandra
    nixd
  ];
}
