{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Nix
    alejandra
    nixd

    # Just
    just-formatter
    just-lsp
  ];
}
