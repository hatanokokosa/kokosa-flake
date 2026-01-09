{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Rust
    rust-analyzer
    rustfmt
    clippy
    bacon
    rustc
    cargo
  ];
}
