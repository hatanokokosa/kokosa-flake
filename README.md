My personal NixOS configuration!

Built with flake-parts + import-tree; modules auto-discover!

## Components
- Security: [OpenDoas] (Sudo disabled)
- Colorscheme: [Catppuccin Latte]
- Desktop: [KDE Plasma 6] + [SDDM]
- Boot: [Linux-zen] Kernel, [GRUB]
- Shell: [Fish] + [Fisher]
- InputMethod: [Fcitx5]
- GUI Editor: [VSCode]
- Browser: [Firefox]
- Terminal: [Kitty]
- Editor: [Neovim]

## Structure
- `nixos/modules/*.nix`: shared modules auto-registered.
- `nixos/hosts/<name>`: host-specific modules auto-registered as `hosts/<name>`; current host `kokosa` imports `hardware.nix`.
- `home/modules` + `home/dotfiles`: Home Manager modules/dotfiles for `hatano`, toggled via `my.hm.<name>.enable` in `nixos/modules/home.nix`.
- `modules/hosts/default.nix`: declares hosts and module lists; `modules/nixos/default.nix` wires registration.

<!-- References -->
[OpenDoas]: https://github.com/Duncaen/OpenDoas
[Catppuccin Latte]: https://catppuccin.com/
[KDE Plasma 6]: https://kde.org/plasma-desktop
[SDDM]: https://wiki.archlinux.org/title/SDDM
[Linux-zen]: https://github.com/zen-kernel/zen-kernel
[GRUB]: https://www.gnu.org/software/grub/
[Fish]: https://fishshell.com
[Fisher]: https://github.com/jorgebucaran/fisher
[Fcitx5]: https://fcitx-im.org/wiki/Fcitx5
[VSCode]: https://code.visualstudio.com
[Firefox]: https://www.mozilla.org/firefox
[Kitty]: https://sw.kovidgoyal.net/kitty/
[Neovim]: https://neovim.io
