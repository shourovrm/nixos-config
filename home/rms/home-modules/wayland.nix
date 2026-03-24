# Shared Wayland session configuration for Niri and MangoWC.
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel        # app launcher helper
    foot          # Wayland-native terminal
    swaylock      # screen locker
    swayidle      # idle management
    wl-clipboard  # clipboard (wl-copy / wl-paste)
    grim          # screenshots
    slurp         # region selection for screenshots
    libnotify     # notify-send
    mako          # notification daemon
    brightnessctl # screen brightness (XF86 keys)
    playerctl     # media playback control (XF86 keys)
    wlopm         # wlroots output power manager (display off/on for MangoWC)
  ];

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      ignore-timeout = false;
    };
  };

  # Niri's swayidle service needs absolute paths because the user unit runs
  # with a minimal PATH.
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

  # Keep wallpaper materialized under the home directory so every session can
  # reference a stable path.
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

    layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
    }

    // ── Key bindings ──────────────────────────────────────────────────────
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

    // ── Startup ───────────────────────────────────────────────────────────
    spawn-at-startup "noctalia-shell"
  '';

  xdg.configFile."mango/config.conf".text = ''
    # MangoWC / mango compositor config
    # Docs: https://mangowm.github.io/docs
    # ── Effect ─────────────────────────────────────────────────────────────
    blur=0
    blur_layer=1
    blur_optimized=1
    blur_params_num_passes=2
    blur_params_radius=5
    blur_params_noise=0.02
    blur_params_brightness=0.9
    blur_params_contrast=0.9
    blur_params_saturation=1.2

    shadows=1
    layer_shadows=1
    shadow_only_floating=1
    shadows_size=12
    shadows_blur=15
    shadows_position_x=0
    shadows_position_y=0
    shadowscolor=0x000000ff

    border_radius=6
    no_radius_when_single=0
    focused_opacity=1.0
    unfocused_opacity=0.85

    # ── Animation ──────────────────────────────────────────────────────────
    animations=1
    layer_animations=1
    animation_type_open=zoom
    animation_type_close=slide
    layer_animation_type_open=slide
    layer_animation_type_close=slide
    animation_fade_in=1
    animation_fade_out=1
    tag_animation_direction=1
    zoom_initial_ratio=0.3
    zoom_end_ratio=0.7
    fadein_begin_opacity=0.5
    fadeout_begin_opacity=0.8
    animation_duration_move=500
    animation_duration_open=400
    animation_duration_tag=350
    animation_duration_close=800
    animation_duration_focus=400
    animation_curve_open=0.46,1.0,0.29,1.1
    animation_curve_move=0.46,1.0,0.29,1
    animation_curve_tag=0.46,1.0,0.29,1
    animation_curve_close=0.08,0.92,0,1
    animation_curve_focus=0.46,1.0,0.29,1

    # ── Appearance / Layout ────────────────────────────────────────────────
    gappih=8
    gappiv=8
    gappoh=15
    gappov=15
    borderpx=2
    no_border_when_single=0
    rootcolor=0x1e1e2eff
    bordercolor=0x505050ff
    focuscolor=0x7fc8ffff
    urgentcolor=0xad401fff
    maximizescreencolor=0xa6d189ff

    scratchpad_width_ratio=0.8
    scratchpad_height_ratio=0.9

    # ── Master-Stack defaults ──────────────────────────────────────────────
    new_is_master=1
    smartgaps=0
    default_mfact=0.55
    default_nmaster=1

    # ── Scroller defaults ──────────────────────────────────────────────────
    scroller_default_proportion=0.8
    scroller_focus_center=0
    scroller_prefer_center=1
    scroller_proportion_preset=0.5,0.8,1.0

    # ── Overview ───────────────────────────────────────────────────────────
    hotarea_size=10
    enable_hotarea=1
    overviewgappi=5
    overviewgappo=30

    # ── Misc ───────────────────────────────────────────────────────────────
    xwayland_persistence=1
    focus_on_activate=1
    sloppyfocus=1
    warpcursor=1
    cursor_size=24
    cursor_hide_timeout=0
    drag_tile_to_tile=1
    single_scratchpad=1
    circle_layout=tile,scroller

    # ── Keyboard ───────────────────────────────────────────────────────────
    repeat_rate=25
    repeat_delay=600
    numlockon=1
    xkb_rules_layout=us,bd
    xkb_rules_variant=,probhat

    # ── Touchpad ───────────────────────────────────────────────────────────
    disable_trackpad=0
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    trackpad_natural_scrolling=1
    disable_while_typing=1
    accel_speed=0.2

    # ── Keybindings ────────────────────────────────────────────────────────
    # Syntax: bind=MODIFIERS,KEY,COMMAND[,PARAMS]
    # Modifiers: SUPER CTRL ALT SHIFT NONE — combined with +

    bind=SUPER,Return,spawn,foot
    bind=SUPER+CTRL,L,spawn,swaylock -f -c 1a1a2e

    bind=SUPER,D,spawn_shell,noctalia-shell ipc call launcher toggle
    bind=SUPER,N,spawn_shell,noctalia-shell ipc call notifications togglePanel
    bind=SUPER,B,spawn_shell,noctalia-shell ipc call controlCenter toggle

    bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl set +10%
    bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl set 10%-

    bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
    bind=NONE,XF86AudioNext,spawn,playerctl next
    bind=NONE,XF86AudioPrev,spawn,playerctl previous

    # Match Niri's screenshot keys and destination directory.
    bind=NONE,Print,spawn_shell,dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"; grim -g "$(slurp)" "$file"
    bind=SUPER,S,spawn_shell,dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"; grim "$file"
    bind=ALT,Print,spawn_shell,dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"; geom="$(mmsg -g -x | awk 'BEGIN { x = y = width = height = "" } $1 == "x" { x = $2 } $1 == "y" { y = $2 } $1 == "width" { width = $2 } $1 == "height" { height = $2 } NF >= 3 && $2 == "x" { x = $3 } NF >= 3 && $2 == "y" { y = $3 } NF >= 3 && $2 == "width" { width = $3 } NF >= 3 && $2 == "height" { height = $3 } END { if (x != "" && y != "" && width != "" && height != "") printf "%s,%s %sx%s", x, y, width, height }')"; [ -n "$geom" ] && grim -g "$geom" "$file"

    bind=SUPER,Q,killclient
    bind=SUPER,F,togglefullscreen
    bind=SUPER,O,toggleoverview

    bind=SUPER,Space,switch_keyboard_layout

    bind=SUPER,H,focusdir,left
    bind=SUPER,L,focusdir,right
    bind=SUPER,J,focusdir,down
    bind=SUPER,K,focusdir,up
    bind=SUPER,Left,focusdir,left
    bind=SUPER,Right,focusdir,right
    bind=SUPER,Down,focusdir,down
    bind=SUPER,Up,focusdir,up

    bind=SUPER+SHIFT,H,exchange_client,left
    bind=SUPER+SHIFT,L,exchange_client,right
    bind=SUPER+SHIFT,J,exchange_client,down
    bind=SUPER+SHIFT,K,exchange_client,up
    bind=SUPER+SHIFT,Left,exchange_client,left
    bind=SUPER+SHIFT,Right,exchange_client,right

    bind=SUPER,R,switch_layout

    bind=SUPER,TAB,focusstack,next
    bind=SUPER+SHIFT,TAB,focusstack,prev

    bind=SUPER,1,view,1
    bind=SUPER,2,view,2
    bind=SUPER,3,view,3
    bind=SUPER,4,view,4
    bind=SUPER,5,view,5
    bind=SUPER+SHIFT,1,tag,1
    bind=SUPER+SHIFT,2,tag,2
    bind=SUPER+SHIFT,3,tag,3
    bind=SUPER+SHIFT,4,tag,4
    bind=SUPER+SHIFT,5,tag,5

    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize

    bind=SUPER+SHIFT,R,reload_config
    bind=SUPER+SHIFT,E,quit

    exec-once=~/.config/mango/autostart.sh
  '';

  home.file.".config/mango/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      export PATH="/run/current-system/sw/bin:/home/rms/.nix-profile/bin:$PATH"

      noctalia-shell &
      mako &

      swayidle -w \
        timeout 300  "swaylock -f -c 1a1a2e" \
        timeout 600  "wlopm --off '*'" \
        resume       "wlopm --on '*'" \
        timeout 10800 \
          "grep -rq Discharging /sys/class/power_supply/ 2>/dev/null \
           && /run/current-system/sw/bin/systemctl suspend || true" \
        before-sleep "swaylock -f -c 1a1a2e" &
    '';
  };
}