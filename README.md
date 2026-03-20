# NixOS Configuration

A flake-based NixOS + Home Manager configuration for the `nixos` host.

## Layout

```text
nixos-config/
├── flake.nix                        # Entry point — inputs & outputs
├── flake.lock                       # Auto-generated, commit this
├── hosts/
│   └── nixos/
│       ├── configuration.nix        # System-level config (boot, network, GNOME…)
│       └── hardware-configuration.nix  # Auto-generated hardware scan
├── home/
│   └── rms/
│       └── home.nix                 # User packages, git, shell, editors…
└── modules/                         # (future) shared reusable NixOS/HM modules
```

## First-time activation

```bash
# 1. Enable flakes for the current shell session (before git is installed)
export NIX_CONFIG="experimental-features = nix-command flakes"

# 2. Rebuild using this repo as the source of truth
sudo nixos-rebuild switch --flake ~/nixos-config#nixos

# 3. After rebuild, git is installed — initialise the repo
cd ~/nixos-config
git init
git add .
git commit -m "feat: initial flake-based NixOS config"

# 4. Push to GitHub
git remote add origin git@github.com:<your-username>/nixos-config.git
git push -u origin main
```

## Day-to-day commands

| Task | Command |
| --- | --- |
| Rebuild & switch | `sudo nixos-rebuild switch --flake ~/nixos-config#laptop` |
| Test without switching | `sudo nixos-rebuild test --flake ~/nixos-config#laptop` |
| Update all inputs | `nix flake update` |
| Garbage collect | `sudo nix-collect-garbage -d` |
| Roll back | `sudo nixos-rebuild switch --rollback` |

## What goes where

| Concern | File |
| --- | --- |
| Bootloader, kernel, filesystems | `hosts/nixos/hardware-configuration.nix` |
| Networking, GNOME, audio, printing | `hosts/nixos/configuration.nix` |
| User apps, shell, git, dotfiles | `home/rms/home.nix` |
| Reusable option sets | `modules/` |
