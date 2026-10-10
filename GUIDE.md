# Configuration Guide

The flake auto-discovers modules.

## Structure Overview

```
lib/
└── default.nix                 # Module discovery and import helpers
modules/
├── flake-parts/                # Flake-level outputs and overlays
└── systems/                    # Supported system architectures
nixos/
├── hosts/<host>/               # Hardware facts and final host policy
├── modules/
│   ├── boot/                   # Bootloader, kernel, and memory capabilities
│   ├── core/                   # Locale, user, and security capabilities
│   ├── desktop/                # Plasma, audio, input, fonts, and theme
│   ├── hardware/               # GPU, Bluetooth, and peripheral capabilities
│   ├── network/                # NetworkManager, firewall, SSH, and proxy
│   └── ...                     # Gaming, media, packages, power, etc.
└── profiles/                   # Orthogonal policy compositions
home/
├── modules/                    # Individual Home Manager capabilities
├── profiles/                   # Home Manager policy compositions
└── dotfiles/                   # Dotfile sources
```

## Architecture Flow

```text
nixos/hosts/kokosa
├─ nixosProfiles.base
├─ nixosProfiles.graphical
├─ nixosProfiles.development
├─ nixosProfiles.gaming
├─ nixosProfiles.creator
├─ nixosProfiles.virtualisation
├─ other orthogonal profiles
├─ hardware-specific modules
└─ hardware.nix
```

A leaf module is a small configuration fragment that uses upstream NixOS
options directly. Importing the module enables that fragment. Profiles compose
related fragments with `imports`; hosts select profiles, add hardware-specific
modules, and make final policy overrides. Profiles never contain filesystem
UUIDs or generated hardware configuration.

## Shared Library (`lib/default.nix`)

Available functions (import via `import "${inputs.self}/lib"`):

| Function | Type | Description |
|----------|------|-------------|
| `stripNixExt` | `String -> String` | Remove `.nix` extension |
| `discoverModules` | `Path -> AttrSet` | Discover `.nix` files and subdirectories with `default.nix` |
| `importAll` | `Path -> [Path]` | List non-default `.nix` paths in one directory |

## NixOS Modules (system-level)

- Configuration fragments live under `nixos/modules/`.
- Category `default.nix` files aggregate related fragments.
- Profiles import only the fragments they need; importing a fragment is its
  enable switch.
- Use upstream NixOS options directly instead of adding one-to-one wrappers.
- Top-level modules are auto-exported as `nixosModules.<name>` by `flake.nix`.
- Define custom options only for modules that provide real parameterization or
  invariants beyond an upstream option.

## Nix Binary Caches

- `nixos/modules/nix/caches.nix` defines direct mirrors and trusted keys.
- `nixos/modules/nix/s4nix.nix` provides the optional selector4nix service;
  use `http://127.0.0.1:5496/` to view progress when enabled.

### Desktop Kernel

- `nixos/modules/boot/cachyos.nix` selects the non-LTO CachyOS latest x86-64-v3
  kernel. The kernel input follows upstream's default branch, and
  `overlays.pinned` preserves upstream package hashes.
- Update normally with `nix flake update`, or update only the kernel with
  `nix flake update nix-cachyos-kernel`, then run `just ci`. Future upstream
  versions are not guaranteed to have binary-cache outputs.
- Fetch all kernel outputs with
  `nix build '.#nixosConfigurations.kokosa.config.boot.kernelPackages.kernel^*' --no-link --max-jobs 0 --builders ''`
  before rebuilding the desktop. This fails instead of compiling locally when
  an output is unavailable. Kernel changes take effect after a manual reboot.

## Host Configuration

- **Flake registration**: `flake.nix`
- **Host composition**: `nixos/hosts/<host>/default.nix`
- **Generated hardware facts**: `nixos/hosts/<host>/hardware.nix`

Template for a host entry:
```nix
{
  nixosProfiles,
  ...
}: {
  imports = [
    nixosProfiles.base
    nixosProfiles.graphical
    ../../modules/hardware/amd-gpu.nix
    ./hardware.nix
  ];

  networking = {
    hostName = "<host>";
    firewall.enable = false;
  };
  system.stateVersion = "24.11";
}
```

Then register it in `flake.nix`.

Example:
```nix
nixosConfigurations.<host> = inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs nixosModules nixosProfiles;
  };
  modules = [ ./nixos/hosts/<host> ];
};
```

### Remote Installation (nixos-anywhere)

- A host installed on a remote machine imports `inputs.disko.nixosModules.disko` and owns a
  `disko.nix` declaring the disk layout. Its host module sets `boot.loader.grub.enable` only:
  disko derives `boot.loader.grub.devices` from the `EF02` partition of that layout.
- `hardware.nix` is rewritten by the installer. `just install <host> root@<ip>` runs
  `--generate-hardware-config nixos-generate-config`, so the host directory must be committed
  first — flake evaluation ignores untracked files.
- The recipe authenticates with `~/.ssh/id_ed25519`, the same key the host config installs for
  root: run `ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<ip>` once on a fresh machine.
- `just vm-test <host>` runs the disk layout and boot inside a VM without a target machine.

### VPS Maintenance

- `irisu` uses the `nixpkgs-stable` input on `nixos-26.05`, together with the
  matching `nixos-mailserver` release branch. `kokosa` continues to use the
  separate `nixpkgs` input on `nixos-unstable`.
- `irisu` is deployed from the repository configuration and `flake.lock`.
  Automatic system upgrades are disabled; the VPS does not refresh inputs
  independently or fetch configuration changes from GitHub.
- For VPS maintenance, deliberately update `nixpkgs-stable` and the matching
  mail module with `nix flake update nixpkgs-stable nixos-mailserver`, then run
  `just ci` and build `.#nixosConfigurations.irisu.config.system.build.toplevel`.
  Review and commit the configuration and lock file changes before deploying
  with `just deploy irisu root@107.150.26.5`.
- Deployments switch the running system and may restart services. Verify mail
  service health after deployment. Kernel updates require a manual reboot.
  Security updates need regular repository maintenance and deployment.
- System generations are not data backups. Mailboxes and other mutable data
  still need independent copies; deployments do not provide data recovery or
  automatic application-health rollback.
- Changing release branches does not reset `system.stateVersion` or
  `mailserver.stateVersion`. Check persistent service formats before a
  downgrade: Redis 8.8 cannot read the RDB format written by Redis 8.10.
  Logical migration must preserve values and expiry timestamps with writers
  stopped; retain the original snapshot until the new service is verified.
- Lego account-key storage can also change across releases. When migrating
  from the flat account-key layout to the legacy `keys/<email>.key` layout,
  preserve the existing registered account key; do not pair a newly generated
  key with cached account metadata. Verify the ACME order/renew unit succeeds.

## Mail Server

- `nixos/profiles/mail.nix` composes `nixos/modules/services/mailserver.nix`, which imports
  `simple-nixos-mailserver` and serves `irisu.org` from host `mail.irisu.org`.
- TLS uses ACME DNS-01: the Cloudflare token lives in `secrets/cloudflare-dns.age`, encrypted to
  the master key and the host key of `irisu` declared in `secrets.nix`.
- Mailbox passwords are `secrets/mail-<account>.age`; `mailserver.accounts` maps an address to
  `passwordFile = config.age.secrets.<name>.path`.
- DNS records owned outside the flake: `A mail`, `MX`, `TXT` SPF, `TXT _dmarc`, and the DKIM key
  printed by the server as `TXT mail._domainkey`. The provider must point PTR at `mail.irisu.org`.

## Home Manager Modules

- Capability modules live under `home/modules/`; their `my.hm.*` options are
  retained because they manage real program configuration and dotfiles.
- Policy fragments live under `home/profiles/` and set those options directly.
- `nixos/modules/home.nix` provides the shared Home Manager integration.
- NixOS profiles append the matching Home Manager profile to
  `home-manager.users.hatano.imports`.
- Keep new modules and dotfiles tracked; flake evaluation only sees the Git tree.
- Basic template:
```nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.<name>;
in {
  options.my.hm.<name> = {
    enable = lib.mkEnableOption "Enable <name> via Home Manager";
    # ...
  };
  config = lib.mkIf cfg.enable {
    programs.<name> = {
      enable = true;
      # ...
    }
  };
}
```

### Home Manager Modules Linking Dotfiles

- Dotfiles: place under `home/dotfiles/<name>/...`.
- Module template:
```nix
{
  config,
  lib,
  homeFiles,
  ...
}: let
  cfg = config.my.hm.<name>;
  dotdir = "${homeFiles}/<name>";
in {
  options.my.hm.<name> = {
    enable = lib.mkEnableOption "Manage <name> dotfiles";
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."<name>/<file or dir>".source = "${dotdir}/<file or dir>";
  };
}
```

## WPS Office Lifecycle

- `pkgs/wps-sandbox.nix`, exported as `pkgs.wps-sandbox` by the default overlay,
  wraps nixpkgs `wpsoffice-cn`. The editor module installs only this wrapper.
- Desktop file associations and `wps`, `et`, `wpp`, and `wpspdf` launch commands
  use a separate PID namespace per invocation. When the foreground session
  exits, remaining processes in that namespace are terminated. Closing a
  document tab alone does not end a session with another window still open.
- Independent launches use WPS multi-instance mode, so exiting one launch
  does not terminate another. Background-only quickstart cannot outlive its
  launcher.
- This is lifecycle isolation, not a security sandbox: networking, the home
  directory, devices, and desktop session access remain available.
- Build without activating the system:
  `nix build .#legacyPackages.x86_64-linux.wps-sandbox --no-link`.

## Font Configuration

- `nixos/modules/desktop/fonts.nix` owns system font packages, generic defaults,
  and rendering settings. User `~/.config/fontconfig/fonts.conf` can override
  rendering settings; check effective values with
  `fc-match -f 'rgba=%{rgba} hintstyle=%{hintstyle}\n' ':family=sans-serif'`.
- Family aliases remain in `config/fontconfig.conf`, loaded as `localConf`.
  Regional substitutions live in `config/fontconfig-languages.conf`, packaged
  through `fonts.fontconfig.confPackages` as `54-nixos-languages.conf` so they
  run after generic defaults are expanded. `/etc/fonts` is owned by the merged
  Fontconfig package; additional rules belong in that package list, not nested
  `environment.etc` entries.
- Browser font preferences can override generic system defaults. Use installed
  family names or `sans-serif`, `serif`, and `monospace`; only edit Firefox
  `prefs.js` after its processes have fully exited.

## Secrets

- Source secrets live under `secrets/*.age`, encrypted to the admin identity.
- `nixos/modules/secrets.nix` imports vaultix and enables `services.userborn`,
  which vaultix needs because it activates through systemd-sysusers and that
  mechanism cannot create normal users.
- Each host publishes its SSH host public key as `vaultix.settings.hostPubkey`.
  `just secret-renc` decrypts every source secret with the admin identity and
  writes a per-host copy under `secrets/cache/<host>/`, encrypted to that host
  key. The cache is committed: a host listed in `flake.vaultix.nodes` without a
  cache entry fails to build.
- `flake.vaultix.nodes` lists the hosts that declare secrets; each of them must
  import the vaultix nixos module.
- The admin identity lives outside the repository, as `flake.vaultix.identity`.
- Reminder: if a new secret file is not tracked by Git, Flake evaluation will not see it.

### Secret Wiring Pattern

Declare the secret in the consuming module (for example
`nixos/modules/services/mailserver.nix` declares `cloudflare-dns` and `mail-kks`) and import
`../secrets.nix` there for the vaultix module. An empty attribute set resolves to
`secrets/<name>.age`:
```nix
{...}: {
  imports = [../secrets.nix];

  vaultix.secrets.<name> = {};
}
```

Consume the decrypted file from that same module via `config.vaultix.secrets.<name>.path`:
```nix
{ config, ... }: {
  services.<service> = {
    # The service reads the decrypted plaintext file from /run/vaultix/...
    passwordFile = config.vaultix.secrets.<name>.path;
  };
}
```

### Add Or Rotate A Password

1. Create or edit the source secret:
   `just secret-edit secrets/<name>.age`
   Put the plaintext password in the file and save.
2. Declare it in the module that consumes it: `vaultix.secrets.<name> = {};`
3. Re-encrypt for the hosts: `just secret-renc`
4. Commit the source secret, the regenerated `secrets/cache/` files and the Nix changes.

## Commands

- Format & Check: `just ci`
- Rebuild current boot: `just switch`
- Rebuild next boot: `just boot`
- Install on a remote host: `just install <host> root@<ip>`
- Test an install in a VM: `just vm-test <host>`
- Deploy to a remote host: `just deploy <host> root@<ip>`
