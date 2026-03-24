# NixOS Configuration

A flake-based NixOS + Home Manager configuration for the `rms-laptop` host, tracking **nixos-unstable**.

## Status

Current installed software and configuration state is tracked in **[STATUS.md](STATUS.md)**.
After every change (new package, module edit, flake update, etc.), open `STATUS.md` and:
1. Update the relevant table in the *Current configuration* section if the change is structural.
2. Append a dated bullet under **Changelog** describing what changed.

Keep entries concise — one line per change is enough.

## Guides

Detailed documentation lives in the [`guides/`](guides/) folder:

| Guide | Contents |
| --- | --- |
| [nixos-install.md](guides/nixos-install.md) | Fresh NixOS install + applying this config on a new machine |
| [flake.md](guides/flake.md) | Rebuilding, updating inputs, adding packages, multi-host setup |
| [niri.md](guides/niri.md) | Niri keybindings, bar widgets, power/idle behaviour, keyring |
| [uv-python.md](guides/uv-python.md) | Python environments, package management, inline deps |
| [neovim.md](guides/neovim.md) | Neovim plugins, LSP, clipboard, keybindings |
| [newsboat.md](guides/newsboat.md) | Newsboat RSS reader, link macros, download queue |
| [latex.md](guides/latex.md) | LaTeX with MiKTeX + VSCode LaTeX Workshop |
| [distrobox.md](guides/distrobox.md) | Running other distros with Distrobox + Podman |
| [mangowc.md](guides/mangowc.md) | MangoWC (mango) Wayland compositor — keybindings, layouts, config |

## Layout

```text
nixos-config/
├── flake.nix                              # Entry point — inputs & outputs
├── flake.lock                             # Auto-generated, commit this
├── STATUS.md                              # Current system state + changelog
├── guides/                                # Detailed how-to guides
│   ├── nixos-install.md
│   ├── flake.md
│   ├── niri.md
│   ├── uv-python.md
│   ├── neovim.md
│   ├── newsboat.md
│   ├── latex.md
│   ├── distrobox.md
│   └── mangowc.md
├── pkgs/                                  # Custom Nix packages (callPackage)
│   ├── fuzzel-handler/                    # fuzzel --dmenu URL/file handler
│   ├── link-handler/                      # Smart URL dispatcher
│   ├── qndl/                              # task-spooler download queue
│   ├── newsboat-utils/                    # Noctalia bar newsboat widgets
│   └── nvim-open/                         # foot+nvim wrapper (auto-close)
├── hosts/
│   └── rms-laptop/
│       ├── configuration.nix              # Machine identity, bootloader, user
│       └── hardware-configuration.nix     # Auto-generated — never edit
├── modules/
│   └── nixos/                             # Shared system-level modules
│       ├── locale.nix
│       ├── desktop.nix                    # GDM/GNOME + Niri/MangoWC sessions
│       ├── audio.nix                      # PipeWire
│       ├── nix-settings.nix               # Flakes, GC, generation limit
│       └── noctalia-system.nix            # Bluetooth, upower, power-profiles
└── home/
    └── rms/
        ├── home.nix                       # Entry point — imports only
        └── home-modules/                  # User-level modules
            ├── packages.nix               # All user packages
            ├── git.nix
            ├── bash.nix
            ├── neovim.nix
            ├── foot.nix                   # foot terminal (Catppuccin Mocha)
            ├── newsboat.nix               # Newsboat RSS reader
            ├── scripts.nix                # Wires pkgs/ custom scripts
            ├── wayland.nix                # Niri + MangoWC user config
            └── noctalia.nix               # Noctalia bar (Home Manager module)
```

## First-time setup on a new machine

For a **fresh NixOS install** see [guides/nixos-install.md](guides/nixos-install.md).

If NixOS is already installed and you just want to apply this config:

```bash
# Enable flakes for the current shell session
export NIX_CONFIG="experimental-features = nix-command flakes"

# Clone the repo
git clone https://github.com/shourovrm/nixos-config.git ~/nixos-config

# Copy your machine's hardware config into the repo
sudo cp /etc/nixos/hardware-configuration.nix \
        ~/nixos-config/hosts/rms-laptop/hardware-configuration.nix

# Apply
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

## Quick commands

| Task | Command / alias |
| --- | --- |
| Rebuild & switch | `nixswitch` |
| Update flake + switch | `nixup` |
| Test without switching | `sudo nixos-rebuild test --flake ~/nixos-config#rms-laptop` |
| Roll back | `sudo nixos-rebuild switch --rollback` |
| Garbage collect | `sudo nix-collect-garbage -d` |

> **Note:** Never change `stateVersion` in `configuration.nix` or `home.nix` after the
> initial install. It records the NixOS release the system was first set up on.

