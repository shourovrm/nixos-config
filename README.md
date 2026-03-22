# NixOS Configuration

A flake-based NixOS + Home Manager configuration for the `laptop` host, tracking **nixos-unstable**.

## Layout

```text
nixos-config/
├── flake.nix                        # Entry point — inputs & outputs
├── flake.lock                       # Auto-generated, commit this
├── hosts/
│   └── laptop/
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
sudo nixos-rebuild switch --flake ~/nixos-config#laptop

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
| Update a single input | `nix flake update nixpkgs` |
| Garbage collect | `sudo nix-collect-garbage -d` |
| Roll back | `sudo nixos-rebuild switch --rollback` |

## Updating the flake (unstable)

Because you track `nixos-unstable`, updates pull in the latest commits from all inputs.

```bash
# 1. Pull latest revisions for all inputs and rewrite flake.lock
sudo nix flake update

# 2. Test the new build without activating it
sudo nixos-rebuild test --flake ~/nixos-config#laptop

# 3. If everything looks good, switch
sudo nixos-rebuild switch --flake ~/nixos-config#laptop

# 4. Commit the updated lock file
git add flake.lock
git commit -m "chore: flake update $(date '+%Y-%m-%d')"

# Optional — reclaim old store paths
sudo nix-collect-garbage -d
```

> **Note:** `stateVersion` in `configuration.nix` and `home.nix` must **not** be changed
> when switching channels. It records the NixOS release your system was *first installed*
> on and is used to preserve backwards-compatible defaults.

## What goes where

| Concern | File |
| --- | --- |
| Bootloader, kernel, filesystems | `hosts/laptop/hardware-configuration.nix` |
| Networking, GNOME, audio, printing | `hosts/laptop/configuration.nix` |
| User apps, shell, git, dotfiles | `home/rms/home.nix` |
| Reusable option sets | `modules/` |
