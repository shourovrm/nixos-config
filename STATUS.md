# System Status

> Keep this file updated after every change. Add a new entry under **Changelog** with today's date and a brief summary of what changed.

---

## Current configuration — 2026-03-23

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
| Wayland compositor | Niri (default) + MangoWC (mango) — switchable at GDM |
| Status bar | Noctalia Shell |
| Wallpaper | `wallhaven_eo2p3w.jpg` (all sessions via `~/.local/share/wallpapers/`) |
| Audio | PipeWire |
| Bluetooth | enabled (blueman) |
| Keyring | gnome-keyring-daemon (PAM auto-unlock at GDM) |
| Keyboard layouts | English (US) + Bangla Probhat — `Super+Space` to switch |

### System packages (in `configuration.nix`)
`git` `wget` `curl` `zathura`

### User packages (Home Manager — `packages.nix`)
`opencode` `firefox` `btop` `ripgrep` `fd` `bat` `eza` `mpv` `gparted` `libreoffice` `evince` `nodejs` `uv` `miktex` `perl` `distrobox` `podman` `newsboat` `yt-dlp` `links2` `taskspooler` `urlscan`

### Custom scripts (Home Manager — `pkgs/` + `scripts.nix`)
| Script | Binary | Purpose |
| --- | --- | --- |
| `fuzzel-handler` | `fuzzel-handler` | fuzzel --dmenu URL/file handler (open, mpv, yt-dlp, etc.) |
| `link-handler` | `link-handler` | Smart URL dispatcher used as newsboat browser |
| `qndl` | `qndl`, `qndl-audio` | Queue downloads with task-spooler (tsp) |
| `newsboat-utils` | `newsboat-count`, `newsboat-open` | Noctalia bar newsboat widget helpers |
| `weather-utils` | `weather-bar`, `weather-open` | Noctalia bar weather widget (wttr.in emoji + temp; 30 min refresh; click shows forecast) |
| `nvim-open` | `nvim-open` | Open files in nvim inside foot; foot closes when nvim exits (desktop entry uses a Neovim icon) |

### VSCode (Home Manager — `vscode.nix`)
Wayland + gnome-libsecret flags; extensions: **LaTeX Workshop** (`james-yu.latex-workshop`)

### Niri session tools (in `home/rms/modules/niri.nix`)
`fuzzel` `foot` `swaylock` `swaybg` `swayidle` `wl-clipboard` `grim` `slurp` `libnotify` `mako` `brightnessctl` `playerctl`

### Active Home Manager modules
| Module | Purpose |
| --- | --- |
| `packages.nix` | User packages |
| `scripts.nix` | Wires `pkgs/` custom scripts into home.packages |
| `vscode.nix` | VSCode with Wayland flags + LaTeX Workshop extension |
| `git.nix` | Git config |
| `bash.nix` | Shell config + general venv auto-activate |
| `foot.nix` | foot terminal — Catppuccin Mocha, JetBrains Mono 10pt, 5% transparency |
| `neovim.nix` | Neovim + LSP servers (clangd, pyright, black, gcc) + wl-clipboard + symlink `home/rms/nvim/` → `~/.config/nvim/` |
| `newsboat.nix` | Newsboat RSS reader — vim keybinds, macros, Catppuccin colours, 22 feeds |
| `niri.nix` | Niri KDL config + session tools + power management |
| `noctalia.nix` | Noctalia bar (widgets, colours, location) |

### Noctalia bar widgets
- **Left:** ControlCenter (distro logo), Network, Bluetooth
- **Center:** Workspace
- **Right:** KeyboardLayout, SystemMonitor (RAM %, net speed, disk % shown inline), Volume, Battery, Weather (CustomButton — wttr.in emoji + temp, click=forecast), Newsboat unread count (CustomButton), DarkMode toggle, Clock, SessionMenu

### Niri keybinds (notable)
| Key | Action |
| --- | --- |
| `Super+D` | Toggle Noctalia launcher |
| `Super+Space` | Switch keyboard layout (next) |
| `Super+T` | Open foot terminal |
| `Super+S` | Full-screen screenshot |
| `Print` | Interactive region screenshot |

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
| 5 min 30 s idle | Monitors off (`niri msg action power-off-monitors`) |
| Before sleep | `swaylock` (lid close, etc.) |
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

### 2026-03-24 (session 8)
- **MangoWC GDM fix:** `services.displayManager.sessionPackages = [ pkgs.mangowc ]` is correct; session appears once system is rebuilt (`sudo nixos-rebuild switch ...`); `mango.desktop` + `niri.desktop` will both be present in `/run/current-system/sw/share/wayland-sessions/`
- **Niri terminal keybind:** changed from `Super+Return` → `Super+T` (`Mod+T { spawn "foot"; }` in `niri.nix`)
- **Install guide:** Rewrote `guides/nixos-install.md` from scratch — now covers minimal ISO boot, wired/Wi-Fi network setup, full-disk partitioning (GPT + UEFI), dual-boot alongside Windows (shrink in Windows, add Linux partition, reuse EFI partition), hardware-config generation, Home Manager first activation, post-install checklist (SSH, Python venv, rclone, session selection), rebuild commands, and troubleshooting

### 2026-03-24 (session 7)
- **MangoWC session:** Added `modules/nixos/mangowc.nix` (system, registers `mango` session with GDM) + `home/rms/modules/mangowc.nix` (user config + autostart); keybindings mirror Niri (Super+Return, Super+H/L/J/K, Super+1-5, etc.); Noctalia Shell + mako + swaybg + swayidle started via autostart.sh; accessible via GDM gear icon → "mango"
- **Wallpaper:** All sessions (Niri, MangoWC, GNOME) now use `wallhaven_eo2p3w.jpg` copied via `home.file` to `~/.local/share/wallpapers/`; GNOME wallpaper set via dconf.settings; MangoWC autostart uses the same path
- **Clock widget:** Noctalia bar clock format updated to `d MMM yy, ddd, hh:mm AP` → "24 Mar 26, Tue, 08:00 AM"
- **Weather widget fix:** weather-bar script now uses `curl -sG --data-urlencode "format=%c %t"` to correctly URL-encode the wttr.in format codes (old `%c%20%t` was decoded as garbage by the server); removed `-f` flag
- **Guide:** Created `guides/mangowc.md` with full keybind reference, layout list, session differences; linked from README
- **nixos-config-v2:** New standalone folder at repo root with greetd+tuigreet login manager, no GDM/GNOME, wlr+gtk portals, wlopm for generic monitor power-off; new modules: `filesystems.nix` (NTFS/exFAT, udisks2, gvfs, Thunar, dconf), `gtk.nix` (adw-gtk3-dark theme), `clipboard.nix` (cliphist systemd service, Super+V picker), `filemanager.nix` (Nautilus, Thunar, rclone, KeePassXC, udiskie); polkit-gnome spawned from compositor startup

### 2026-03-23 (session 4)
- **Fix:** `switch-keyboard-layout` is not a valid niri action name; corrected to `switch-layout "next"` — niri config was failing to parse, causing the status bar and wallpaper not to load; confirmed valid with `niri validate`

### 2026-03-23 (session 5)
- **Foot:** updated the terminal colour section to `[colors-dark]` to match upstream foot syntax and remove the deprecation warning
- **Neovim wrapper:** `nvim-open` now execs Neovim through foot with a proper app id/title, and the Home Manager desktop entry now advertises Neovim instead of a generic launcher
- **Widgets:** weather now shows a weather symbol plus temperature from wttr.in, and Newsboat now shows the unread count directly in the bar

### 2026-03-23 (session 6)
- **Widgets:** hid the built-in left icon on both Noctalia CustomButton widgets so the weather and Newsboat buttons stay text-only apart from their emoji/status text

### 2026-03-23 (session 3)
- **Fix:** `packages.nix` had a syntax error (`];` merged onto same line as `urlscan`) — fixed
- **Fix:** `task-spooler` is not a valid Nix identifier; corrected to `taskspooler` (the actual nixpkgs attribute name)
- **Weather widget:** Added `pkgs/weather-utils/` with `weather-bar` (fetches current temperature from `wttr.in`, 30 min refresh) and `weather-open` (opens full 3-day forecast in foot terminal); wired into `scripts.nix`, `flake.nix`, and Noctalia bar as a `CustomButton` widget before Newsboat

### 2026-03-23 (session 2)
- **Keyboard layout:** `Alt+Shift` → `Super+Space`; added `KeyboardLayout` widget to Noctalia bar right side
- **Noctalia launcher:** `Super+D` now opens Noctalia launcher (was fuzzel); fuzzel still available via `fuzzel-handler`
- **DarkMode widget:** Added DarkMode toggle to Noctalia bar right side
- **Neovim:** Fixed all 12 plugin specs (missing name as first element); `init.lua` now returns `{}` (lazy auto-discovers); `git.lua` refactored to include vim-rhubarb; added `wl-clipboard` to extraPackages for Wayland clipboard (`unnamedplus` register)
- **pkgs/ system:** Created custom derivations: `fuzzel-handler`, `link-handler`, `qndl` (+ `qndl-audio`), `newsboat-utils` (`newsboat-count`/`newsboat-open`), `nvim-open`; wired via `scripts.nix`; also registered in `flake.nix` packages output
- **Newsboat:** Full setup — `programs.newsboat` HM config, vim keybinds, macros (`,v`,t`,a`,w`,d`,c`), Catppuccin colours, 22 feeds (news, Reddit, YouTube, arXiv); Noctalia bar widget shows unread count
- **foot:** `programs.foot` HM config — Catppuccin Mocha, JetBrains Mono 10pt, 5% transparency, beam cursor, 10 000-line scrollback
- **Packages added:** `newsboat` `yt-dlp` `links2` `task-spooler` `urlscan`
- **Guides:** Updated `neovim.md` (clipboard section, init.lua note); created `newsboat.md`

### 2026-03-23
- Added repo-wide comments to all Nix and Lua configuration files so each segment is easier to read
- Added `distrobox` plus `podman` support and created `guides/distrobox.md`
- Fixed Noctalia SystemMonitor to show values inline again by disabling compact mode
- Updated `.gitignore` to exclude LaTeX build artefacts and editor scratch files
- Verified `nixos-rebuild switch` succeeded after the changes
- Confirmed the 3-hour battery suspend rule is working as intended; it only suspends when the machine is actually discharging

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

### 2026-03-22 (idle fix)
- Fixed swayidle monitor power-off: swayidle's systemd unit has a restricted PATH (bash only); `niri msg`, `grep`, `systemctl` were not found → silently failed; now use full Nix store paths (`${pkgs.niri}/bin/niri`, `${pkgs.gnugrep}/bin/grep`, `/run/current-system/sw/bin/systemctl`)
- Monitors now turn off 30 s after the lock screen (was 10 min; was also broken)
- Added `before-sleep` event to lock screen before suspend (lid close etc.)
- Confirmed: GNOME session manager is NOT bleeding into Niri (`gsd-power` and `gnome-session` are not running in the Niri user session)
