{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Core CLI Tools
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
    zoxide
    broot
    codex
    cloc
    yazi
    cava
    fish
    btop
    wget
    rip2
    dog
    duf
    lsd
    bat
    fd
  ];
}
