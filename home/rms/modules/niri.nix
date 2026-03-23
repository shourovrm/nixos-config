# home/rms/modules/niri.nix
# Niri compositor user configuration and helper tools.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel          # app launcher (Mod+Space)
    foot            # Wayland-native terminal (Mod+T)
    swaylock        # screen locker
    swaybg          # wallpaper setter
    swayidle        # idle management
    wl-clipboard    # clipboard (wl-copy / wl-paste)
    grim            # screenshots
    slurp           # region selection for screenshots
    libnotify       # notify-send
    mako            # notification daemon
    brightnessctl   # screen brightness (XF86 keys)
    playerctl       # media playback control (XF86 keys)
  ];

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;   # dismiss notifications after 5 s
      ignore-timeout  = false;
    };
  };

  # ── Idle / power management ───────────────────────────────────────────────
  # Root cause of previous failure: swayidle's systemd unit has a restricted
  # PATH (only bash's bin dir). Commands like `niri`, `grep`, `systemctl` are
  # not in that PATH and fail silently. Fix: use full Nix store paths for
  # every external binary.
  #
  # GNOME bleed verdict: NO. Running `systemctl --user list-units` in the
  # Niri session confirms that gsd-power and gnome-session are NOT running.
  # programs.niri on NixOS keeps GNOME autostart entries (OnlyShowIn=GNOME)
  # out of the Niri session.
  services.swayidle = {
    enable = true;
    events = [
      # Lock the screen before the system suspends (e.g. lid close)
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a2e"; }
    ];
    timeouts = [
      # 5 min idle → lock screen
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a2e";
      }
      # 5 min 30 s idle → turn monitors off (30 s grace after lock)
      # Full path required: swayidle's unit PATH only contains bash's bin.
      {
        timeout = 330;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      # 3 h idle on battery → suspend
      {
        timeout = 10800;
        command = ''${pkgs.gnugrep}/bin/grep -rq Discharging /sys/class/power_supply/ 2>/dev/null && /run/current-system/sw/bin/systemctl suspend || true'';
      }
    ];
  };

  # ── Secret service (keyring) ─────────────────────────────────────────────
  # gnome-keyring-daemon implements org.freedesktop.Secret.Service.
  # It is a small daemon (~3 MB RAM) — NOT gnome-shell or any GNOME desktop.
  # PAM unlocks it at GDM login (see modules/nixos/desktop.nix).
  # Most apps (Thunderbird etc.) use libsecret automatically and need no flag.
  # Chromium-based/Electron apps need an explicit flag because they don't
  # auto-detect the secret store in non-GNOME Wayland sessions.
  services.gnome-keyring.enable = true;

  # Chromium / Electron global flags — read by Chromium, Chrome, and most
  # Electron apps (VS Code uses its own override in packages.nix instead).
  home.file.".config/chromium-flags.conf".text = ''
    --ozone-platform=wayland
    --password-store=gnome-libsecret
  '';

  # Polkit authentication agent for privilege dialogs inside niri
  services.polkit-gnome.enable = true;

  # Niri compositor config (~/.config/niri/config.kdl)
  xdg.configFile."niri/config.kdl".text = ''
    // ── Appearance ────────────────────────────────────────────────────────
    prefer-no-csd

    window-rule {
      geometry-corner-radius 12
      clip-to-geometry true
    }

    // Required for Noctalia notification actions and window activation
    debug {
      honor-xdg-activation-with-invalid-serial
    }

    // ── Input ─────────────────────────────────────────────────────────────
    input {
      keyboard {
        xkb {
          layout "us,bd"        // us = English, bd = Bangla
          variant ",probhat"    // second layout uses Probhat
          // No grp: toggle option needed — niri's own Super+Space bind handles layout cycling
        }
      }
      touchpad {
        tap
        natural-scroll
        accel-speed 0.2
      }
    }

    // ── Layout ────────────────────────────────────────────────────────────
    layout {
      gaps 8
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#7fc8ff"
        inactive-color "#505050"
      }

      border {
        off
      }
    }

    // ── Noctalia layer rule — blurred overview backdrop ───────────────────
    layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
    }

    // ── Key bindings ──────────────────────────────────────────────────────
    binds {
      // Apps
      Mod+T { spawn "foot"; }

      Mod+Ctrl+L { spawn "swaylock" "-f"; }

      // Volume (wpctl comes with PipeWire)
      XF86AudioRaiseVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute         { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute      { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      // Brightness
      XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

      // Media
      XF86AudioPlay  { spawn "playerctl" "play-pause"; }
      XF86AudioNext  { spawn "playerctl" "next"; }
      XF86AudioPrev  { spawn "playerctl" "previous"; }

      // Window management
      Mod+Q { close-window; }

      Mod+Left  { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up    { focus-window-up; }
      Mod+Down  { focus-window-down; }
      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }

      Mod+Shift+Left  { move-column-left; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }

      Mod+F       { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+C       { center-column; }

      Mod+R     { switch-preset-column-width; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }

      // Workspaces
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+Shift+4 { move-window-to-workspace 4; }
      Mod+Shift+5 { move-window-to-workspace 5; }

      // Screenshots
      // Print → interactive region select; Mod+S → full screen
      Print     { screenshot; }
      Mod+S     { screenshot-screen; }
      Alt+Print { screenshot-window; }

      // Niri
      Mod+Shift+E { quit; }
      Mod+O       { toggle-overview; }

      // Noctalia IPC
      Mod+D     { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }  // open Noctalia launcher
      Mod+N     { spawn "noctalia-shell" "ipc" "call" "notifications" "togglePanel"; }
      Mod+B     { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }

      // Keyboard layout: cycle through configured XKB layouts (Super+Space)
      Mod+Space { switch-keyboard-layout "next"; }
    }

    // ── Startup ───────────────────────────────────────────────────────────
    spawn-at-startup "noctalia-shell"
    // Put a wallpaper at ~/Pictures/wallpaper.jpg or change this path:
    spawn-at-startup "swaybg" "-i" "/home/rms/Pictures/wallpaper.jpg" "-m" "fill"
  '';
}
