{pkgs, ...}: {
  imports = [
    ./packages/cli.nix
    ./packages/dev.nix
    ./packages/gaming.nix
  ];

  # System Packages - Editors, Daily Use, Drivers
  environment.systemPackages = with pkgs; [
    # Editors
    nur.repos.novel2430.wpsoffice-365
    antigravity-fhs
    evil-helix
    neovim

    # Daily Use
    kdePackages.partitionmanager
    kdePackages.kdenlive
    telegram-desktop
    obs-studio
    handbrake
    anki-bin
    obsidian
    openutau
    firefox
    upscayl
    haruna
    krita
    rnote
    qq

    # Driver
    hid-bpf-uclogic
    huion-switcher
    hid-tools
  ];
}
