{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Dev Tools
    distrobox
    boxbuddy
    lazygit
    jujutsu
    direnv
    kitty
    just
    git
    gcc

    # RUST
    rust-analyzer
    rustfmt
    clippy
    rustc
    cargo

    # Just
    just-formatter
    just-lsp

    # Nix
    alejandra
    nixd

    # Python (single version to avoid confusion)
    python313
    ruff

    # C/C++
    clang-tools
    clang

    # Go
    gopls
    go

    # JS/TS
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.nodejs
    nodePackages.pnpm
  ];
}
