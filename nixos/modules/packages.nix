{pkgs, ...}: {
  programs.appimage.binfmt = true;

  # Steam
  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
    };
    nix-index.enable = false;
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # VSCode & Extensions
    # (vscode-with-extensions.override {
    #   vscode = vscode;
    #   vscodeExtensions = with vscode-extensions; [
    #     ms-ceintl.vscode-language-pack-zh-hans
    #     github.vscode-pull-request-github
    #     github.copilot-chat
    #     github.copilot
    #     vscodevim.vim
    #     bierner.github-markdown-preview
    #     yzhang.markdown-all-in-one
    #     astro-build.astro-vscode
    #     james-yu.latex-workshop
    #     kamadorueda.alejandra
    #     jnoortheen.nix-ide
    #     catppuccin.catppuccin-vsc-icons
    #     catppuccin.catppuccin-vsc
    #   ];
    # })

    # Editors
    nur.repos.novel2430.wpsoffice-365
    evil-helix
    neovim
    vim

    # Cli Tools
    claude-code-router
    wl-clipboard-rs
    translate-shell
    appimage-run
    ripgrep-all
    ffmpeg-full
    libva-utils
    claude-code
    go-musicfox
    amdgpu_top
    fastfetch
    rustscan
    tealdeer
    ripgrep
    libwebp
    libwebm
    ffmpeg
    zellij
    zoxide
    broot
    codex
    dust
    skim
    cloc
    yazi
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
    zerotierone
    easytier
    sparkle
    v2raya
    motrix

    # Game Dev
    gdtoolkit_4
    godot

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

    # Coding Tools
    rust-analyzer
    rustfmt
    clippy
    rustc
    cargo

    just-formatter
    just-lsp

    alejandra
    nixd

    python314
    python313
    ruff

    clang-tools
    clang

    gopls
    go

    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.nodejs
    nodePackages.pnpm

    # Gaming
    nur.repos.chillcicada.et-astral
    wineWow64Packages.full
    winePackages.fonts
    prismlauncher
    protonplus
    winetricks
    wineasio
    mangohud
    corectrl
    scanmem
    bottles
    clinfo
    vkd3d
    dxvk

    # Daily Use
    kdePackages.partitionmanager
    kdePackages.markdownpart
    kdePackages.kdenlive
    kdePackages.kalzium
    telegram-desktop
    zed-editor-fhs
    cherry-studio
    obs-studio
    handbrake
    obsidian
    upscayl
    firefox
    haruna
    krita
    rnote
    pix
    qq

    # Driver
    hid-bpf-uclogic
    huion-switcher
    hid-tools
  ];
}
