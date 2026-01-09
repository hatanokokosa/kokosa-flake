{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Archive Tools
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
