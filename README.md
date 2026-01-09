<h1 align="center">
    <img src="/home/dotfiles/fastfetch/kokosa.png" alt="logo" width="400px" />
    <br>
        Kokosa's NixOS Flakes
    <br>
    <a href="https://github.com/catppuccin/catppuccin">
        <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/refs/heads/main/assets/palette/latte.png" width="600px" />
    </a>
    <br>
</h1>

<p align="center">
    My personal NixOS configuration! Built with flake-parts~
</p>

<div align="center">
    <a href="https://github.com/hatanokokosa/kokosa-flake">
        <img src="https://img.shields.io/github/repo-size/hatanokokosa/kokosa-flake?color=C6A0F6&logoColor=eff1f5&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6" alt="Repo Size">
    </a>
    <a href="https://nixos.org">
        <img src="https://img.shields.io/badge/NixOS-Unstable-04a5e5?style=for-the-badge&logo=NixOS&logoColor=eff1f5&label=NixOS&labelColor=4c4f69&color=04a5e5" alt="NixOS Unstable">
    </a>
    <a href="https://opensource.org/license/bsd-2-clause">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=BSD2-Clause&colorA=4c4f69&colorB=dc8a78&logo=unlicense&logoColor=dc8a78" alt="BSD 2-Clause"></a>
    </a>
</div>

## Features
- Colorscheme: [Catppuccin]
- Desktop: [KDE Plasma 6]
- InputMethod: [Fcitx5]
- Security: [OpenDoas]
- GUI Editor: [VSCode]
- Shell: [Fish] & [Fisher]
- Kernel: [Linux-zen]
- Browser: [Firefox]
- Editor: [Neovim]
- Terminal: [Kitty]

## Structure
- `modules/`: flake-parts helpers for formatter, systems, and host registry
- `lib/`: shared utility functions (module discovery, etc.)
- `flake.nix`: flake entry with inputs and outputs
- `home/`: Home Manager modules and dotfiles
- `nixos/`: shared modules and host profiles

---

```fish
▓██ ▄█▀ ▒█████   ██ ▄█▀ ▒█████    █████   ██▄       
▓██▄█▒ ▒██▒  ██▒ ██▄█▒ ▒██▒  ██▒▒██    ▒ ▒████▄     
▓███▄░ ▒██░  ██▒▓███▄░ ▒██░  ██▒░ ▓██▄   ▒██  ▀█▄   
▓██ █▄ ▒██   ██░▓██ █▄ ▒██   ██░  ▒   ██▒░██▄▄▄▄██  
▒██▒ █▄░ ████▓▒░▒██▒ █▄░ ████▓▒░▒██████▒▒ ▓█   ▓██▒ 
▒ ▒▒ ▓▒░ ▒░▒░▒░ ▒ ▒▒ ▓▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░ ▒▒   ▓▒█░ 
░ ░▒ ▒░  ░ ▒ ▒░ ░ ░▒ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░  ▒   ▒▒ ░ 
░  ░ ░ ░ ░ ░    ░  ░ ░ ░   ░ ▒     ░       ░   ▒    
    ░       ░          ░     ░ ░           ░   ░

~ [211]$ doas echo "Ciallo～(∠・ω< )⌒☆ World!" > /boot/kernels/*
```

<!-- References -->
[OpenDoas]: https://github.com/Duncaen/OpenDoas
[Catppuccin]: https://catppuccin.com/
[KDE Plasma 6]: https://kde.org/plasma-desktop
[Linux-zen]: https://github.com/zen-kernel/zen-kernel
[Fish]: https://fishshell.com
[Fisher]: https://github.com/jorgebucaran/fisher
[Fcitx5]: https://fcitx-im.org/wiki/Fcitx5
[VSCode]: https://code.visualstudio.com
[Firefox]: https://www.mozilla.org/firefox
[Kitty]: https://sw.kovidgoyal.net/kitty/
[Neovim]: https://neovim.io
