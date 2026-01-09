{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Rust
    rust-analyzer
    rustfmt
    clippy
    rustc
    cargo
  ];
}
