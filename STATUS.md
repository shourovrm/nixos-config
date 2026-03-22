# System Status

> Keep this file updated after every change. Add a new entry under **Changelog** with today's date and a brief summary of what changed.

---

## Current configuration — 2026-03-22

### Host
| Field | Value |
| --- | --- |
| Hostname | `rms-laptop` |
| Channel | `nixos-unstable` |
| State version | `25.11` |
| Boot | GRUB + EFI |

### Desktop
| Concern | Detail |
| --- | --- |
| Display manager | GDM |
| Desktop (fallback) | GNOME |
| Wayland compositor | Niri |
| Status bar | Noctalia Shell |
| Audio | PipeWire |
| Bluetooth | enabled (blueman) |
| Keyring | gnome-keyring-daemon (PAM auto-unlock at GDM) |
| Keyboard layouts | English (US) + Bangla Probhat — `Alt+Shift` to switch |

### System packages (in `configuration.nix`)
`git` `wget` `curl` `zathura`

### User packages (Home Manager — `packages.nix`)
`opencode` `firefox` `btop` `ripgrep` `fd` `bat` `eza` `mpv` `gparted` `libreoffice` `evince` `nodejs` `uv` `miktex` `perl`

### VSCode (Home Manager — `vscode.nix`)
Wayland + gnome-libsecret flags; extensions: **LaTeX Workshop** (`james-yu.latex-workshop`)

### Niri session tools (in `home/rms/modules/niri.nix`)
`fuzzel` `foot` `swaylock` `swaybg` `swayidle` `wl-clipboard` `grim` `slurp` `libnotify` `mako` `brightnessctl` `playerctl`

### Active Home Manager modules
| Module | Purpose |
| --- | --- |
| `packages.nix` | User packages |
| `vscode.nix` | VSCode with Wayland flags + LaTeX Workshop extension |
| `git.nix` | Git config |
| `bash.nix` | Shell config + general venv auto-activate |
| `neovim.nix` | Neovim + LSP servers (clangd, pyright, black, gcc) + symlink `home/rms/nvim/` → `~/.config/nvim/` |
| `niri.nix` | Niri KDL config + session tools + power management |
| `noctalia.nix` | Noctalia bar (widgets, colours, location) |

### Noctalia bar widgets
- **Left:** ControlCenter (distro logo), Network, Bluetooth
- **Center:** Workspace
- **Right:** SystemMonitor (RAM %, net speed, disk %), Volume, Battery, Clock, SessionMenu

### Screenshot keybinds
| Key | Action |
| --- | --- |
| `Print` | Interactive region select |
| `Super + S` | Full-screen screenshot |
| `Alt + Print` | Active window screenshot |

### Idle / power (swayidle)
| Trigger | Action |
| --- | --- |
| 5 min idle | `swaylock` dark screen (`-c 1a1a2e`) |
| 10 min idle | Monitors off |
| 3 h idle on battery | Suspend |
| On AC power | Never auto-suspends |

### Notification timeout (mako)
5 seconds (`default-timeout = 5000`)

### Python environments (uv)
| Env | Path | Purpose |
| --- | --- | --- |
| general (default) | `~/.venv/general` | Everyday packages; auto-activated in bash |

---

## Changelog

### 2026-03-22
- Restructured repo layout (moved hosts, modules into final folder structure)
- Added Niri Wayland session and all session tools
- Added Noctalia Shell bar
- Added GNOME keyring + Chromium/Electron secret-service flags
- Ran `nix flake update`
- Added `STATUS.md` (this file) and linked from README
- Stripped README to layout + quick-start; moved all guides to `guides/`
- Created `guides/nixos-install.md`, `guides/flake.md`, `guides/niri.md`, `guides/uv-python.md`
- Added `uv` package; general venv at `~/.venv/general` auto-activates in bash
- Enriched Noctalia bar: added SystemMonitor (RAM %, net speed, disk %), Volume, SessionMenu
- Fixed Mako notifications: now auto-dismiss after 5 s (`default-timeout = 5000`)
- Screenshot keys swapped: `Print` → interactive region, `Super+S` → fullscreen
- Power management: swaylock (dark) after 5 min, monitors off after 10 min, suspend on battery after 3 h; AC never auto-suspends

### 2026-03-22 (continued)
- **LaTeX**: added `miktex` + `perl`; VSCode moved to `vscode.nix` with `programs.vscode` + LaTeX Workshop extension; auto-build on save, side-by-side PDF preview, SyncTeX; see `guides/latex.md`
- **Neovim**: full config migrated from external drive into `home/rms/nvim/`; symlinked by HM via `xdg.configFile`; lazy.nvim manages plugins; LSP servers (clangd, pyright) + formatters (black, clang-format) provided by Nix; see `guides/neovim.md`
