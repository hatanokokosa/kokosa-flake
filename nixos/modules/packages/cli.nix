{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Cli Tools
    wl-clipboard-rs
    translate-shell
    appimage-run
    ripgrep-all
    ffmpeg-full
    libva-utils
    go-musicfox
    amdgpu_top
    fastfetch
    rustscan
    tealdeer
    ripgrep
    libwebp
    libwebm
    zellij
    zoxide
    broot
    codex
    dust
    cloc
    yazi
    cava
    fish
    btop
    wget
    rip2
    viu
    dog
    duf
    lsd
    bat
    fd

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

    # Network Tools
    qbittorrent-enhanced
    v2raya
    motrix
  ];
}
