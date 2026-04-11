{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rust-analyzer
    rustfmt
    clippy
    bacon
    rustc
    cargo
  ];
}
