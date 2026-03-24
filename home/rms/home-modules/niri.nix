# Niri compositor user configuration and shared Wayland user services.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel          # app launcher
    foot            # Wayland-native terminal
    swaylock        # screen locker
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
      default-timeout = 5000;
      ignore-timeout = false;
    };
  };

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a2e";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a2e";
      }
      {
        timeout = 330;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 10800;
        command = ''${pkgs.gnugrep}/bin/grep -rq Discharging /sys/class/power_supply/ 2>/dev/null && /run/current-system/sw/bin/systemctl suspend || true'';
      }
    ];
  };

  home.file.".local/share/wallpapers/wallhaven_eo2p3w.jpg".source =
    ../../../wallhaven_eo2p3w.jpg;

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/rms/.local/share/wallpapers/wallhaven_eo2p3w.jpg";
      picture-uri-dark = "file:///home/rms/.local/share/wallpapers/wallhaven_eo2p3w.jpg";
      picture-options = "zoom";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/rms/.local/share/wallpapers/wallhaven_eo2p3w.jpg";
      picture-options = "zoom";
    };
  };

  services.gnome-keyring.enable = true;

  home.file.".config/chromium-flags.conf".text = ''
    --ozone-platform=wayland
    --password-store=gnome-libsecret
  '';

  services.polkit-gnome.enable = true;

  xdg.configFile."niri/config.kdl".text = ''
    prefer-no-csd

    window-rule {
      geometry-corner-radius 12
      clip-to-geometry true
    }

    debug {
      honor-xdg-activation-with-invalid-serial
    }

    input {
      keyboard {
        xkb {
          layout "us,bd"
          variant ",probhat"
        }
      }
      touchpad {
        tap
        natural-scroll
        accel-speed 0.2
      }
    }

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

    layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
    }

    binds {
      Mod+T { spawn "foot"; }
      Mod+Ctrl+L { spawn "swaylock" "-f"; }

      XF86AudioRaiseVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute         { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute      { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

      XF86AudioPlay  { spawn "playerctl" "play-pause"; }
      XF86AudioNext  { spawn "playerctl" "next"; }
      XF86AudioPrev  { spawn "playerctl" "previous"; }

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

      Print     { screenshot; }
      Mod+S     { screenshot-screen; }
      Alt+Print { screenshot-window; }

      Mod+Shift+E { quit; }
      Mod+O       { toggle-overview; }

      Mod+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
      Mod+N { spawn "noctalia-shell" "ipc" "call" "notifications" "togglePanel"; }
      Mod+B { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }

      Mod+Space { switch-layout "next"; }
    }

    spawn-at-startup "noctalia-shell"
  '';
}