{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Archive Tools
    gnutar
    bzip3
    p7zip
    unzip
    gzip
    zstd
    unar
    lz4
    zip
    rar
    xz
  ];
}
