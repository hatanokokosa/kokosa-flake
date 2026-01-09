{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # (De)Compress Tools
    gnutar
    bzip3
    p7zip
    unzip
    zstd
    gzip
    ouch
    lz4
    zip
    rar
    xz
  ];
}
