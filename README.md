# NixOS Configuration

A flake-based NixOS + Home Manager configuration for the `rms-laptop` host, tracking **nixos-unstable**.

## Layout

```text
nixos-config/
├── flake.nix                              # Entry point — inputs & outputs
├── flake.lock                             # Auto-generated, commit this
├── hosts/
│   └── rms-laptop/
│       ├── configuration.nix              # Machine identity, bootloader, user
│       └── hardware-configuration.nix     # Auto-generated — never edit
├── modules/
│   └── nixos/                             # Shared system-level modules
│       ├── locale.nix
│       ├── desktop.nix                    # GNOME + GDM + printing
│       ├── audio.nix                      # PipeWire
│       ├── nix-settings.nix               # Flakes, GC, generation limit
│       ├── niri.nix                       # Niri Wayland session
│       └── noctalia-system.nix            # Bluetooth, upower, power-profiles
└── home/
    └── rms/
        ├── home.nix                       # Entry point — imports only
        └── modules/                       # User-level modules
            ├── packages.nix               # All user packages
            ├── git.nix
            ├── bash.nix
            ├── neovim.nix
            ├── niri.nix                   # KDL config + niri tools
            └── noctalia.nix               # Noctalia bar (Home Manager module)
```

## First-time activation

```bash
# 1. Enable flakes for the current shell session (before git is installed)
export NIX_CONFIG="experimental-features = nix-command flakes"

# 2. Rebuild using this repo as the source of truth
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop

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
| Rebuild & switch | `sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop` |
| Test without switching | `sudo nixos-rebuild test --flake ~/nixos-config#rms-laptop` |
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
sudo nixos-rebuild test --flake ~/nixos-config#rms-laptop

# 3. If everything looks good, switch
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop

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
| Bootloader, kernel, filesystems | `hosts/rms-laptop/hardware-configuration.nix` |
| Machine identity, user account | `hosts/rms-laptop/configuration.nix` |
| Locale, desktop, audio, Nix GC | `modules/nixos/*.nix` |
| User apps, shell, git, editors | `home/rms/modules/*.nix` |

## Adding packages or software

**Rule of thumb:** one-line installs → add to an existing file; richer config → new dedicated file.

### User package (no config needed)
Add to `home/rms/modules/packages.nix`:
```nix
home.packages = with pkgs; [
  my-new-package   # ← just add it here
];
```

### System package (needs root / available before login)
Add to `environment.systemPackages` in `hosts/rms-laptop/configuration.nix`.

### Program with Home Manager options (git, bash, neovim, etc.)
If the config is a few lines, add it to the closest existing module (`bash.nix`, `neovim.nix`, etc.).
If it grows beyond ~20–30 lines, create a new file:
```
home/rms/modules/my-program.nix
```
Then import it in `home/rms/home.nix`:
```nix
imports = [
  ...
  ./modules/my-program.nix
];
```

### New system-level concern (display manager, VPN, firewall, etc.)
Create `modules/nixos/my-concern.nix` and import it in `hosts/rms-laptop/configuration.nix`.

---

## Secret service / keyring in Niri

`gnome-keyring-daemon` runs as a small background daemon (~3 MB RAM). It is **not** gnome-shell or any GNOME desktop — just a D-Bus secret-service implementation. It is auto-unlocked at GDM login via PAM (see `modules/nixos/desktop.nix`).

Most apps that use `libsecret` (Thunderbird, GNOME apps, etc.) work automatically with no extra config.

**Chromium-based and Electron apps** need explicit flags because they don't auto-detect the secret store in non-GNOME Wayland sessions:

| App | How it's handled |
| --- | --- |
| VS Code | `--password-store=gnome-libsecret` in its override in `home/rms/modules/packages.nix` |
| Chromium / Chrome | `~/.config/chromium-flags.conf` (written by Home Manager in `home/rms/modules/niri.nix`) |
| Any other Electron app showing the popup | Add `home.file.".config/<appname>-flags.conf".text` with the same two lines to `niri.nix` |

The two lines to put in any such flags file:
```
--ozone-platform=wayland
--password-store=gnome-libsecret
```

---

## Niri session quick reference

At the GDM login screen, click the **gear icon** and pick **Niri** to switch sessions. GNOME remains available the same way.

### Keyboard layout
| Action | Keys |
| --- | --- |
| Switch English ↔ Bangla (Probhat) | `Alt + Shift` |

### Applications
| Action | Keys |
| --- | --- |
| Open terminal (foot) | `Super + T` |
| Open app launcher (fuzzel) | `Super + Space` |
| Lock screen | `Super + Ctrl + L` |

### Windows & columns
| Action | Keys |
| --- | --- |
| Close window | `Super + Q` |
| Focus left / right | `Super + H/L` or `Super + ←/→` |
| Focus up / down in column | `Super + J/K` or `Super + ↑/↓` |
| Move column left / right | `Super + Shift + H/L` |
| Maximise column | `Super + F` |
| Fullscreen window | `Super + Shift + F` |
| Centre column | `Super + C` |
| Cycle column widths (⅓ ½ ⅔) | `Super + R` |
| Shrink / grow column | `Super + -` / `Super + =` |

### Workspaces
| Action | Keys |
| --- | --- |
| Switch to workspace 1–5 | `Super + 1–5` |
| Move window to workspace 1–5 | `Super + Shift + 1–5` |

### Screenshots
| Action | Keys |
| --- | --- |
| Interactive region screenshot | `Super + S` |
| Full-screen screenshot | `Print` |
| Active window screenshot | `Alt + Print` |

### Noctalia bar
| Action | Keys |
| --- | --- |
| Toggle launcher | `Super + Space` |
| Toggle notification panel | `Super + N` |
| Toggle control centre | `Super + B` |
| Toggle overview | `Super + O` |

### Session
| Action | Keys |
| --- | --- |
| Quit niri | `Super + Shift + E` |

---

### New host (second machine)
```
hosts/
└── rms-desktop/
    ├── configuration.nix          # imports same modules/nixos/* as laptop
    └── hardware-configuration.nix
```
Add a new `nixosConfigurations.rms-desktop` entry in `flake.nix`.
All `modules/nixos/` and `home/rms/modules/` files reuse unchanged.

