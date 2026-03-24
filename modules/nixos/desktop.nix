# modules/nixos/desktop.nix
# Display manager (GDM), fallback desktop (GNOME), and Wayland session entry
# points. GDM is the login screen; GNOME remains available as fallback.
{ pkgs, ... }:

{
  services.xserver.enable              = true;  # X server needed even for Wayland GDM
  services.displayManager.gdm.enable   = true;  # GNOME Display Manager (login screen)
  services.desktopManager.gnome.enable = true;  # full GNOME session available as fallback

  programs.niri.enable = true;
  services.displayManager.sessionPackages = [ pkgs.mangowc ];
  environment.systemPackages = [ pkgs.mangowc ];

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
    config.niri = { default = [ "gnome" "gtk" ]; };
    config.mango = { default = [ "wlr" "gtk" ]; };
  };

  services.xserver.xkb = {
    layout  = "us,bd";      # us = English, bd = Bangla
    variant = ",probhat";   # first layout has no variant; second uses Probhat
    options = "grp:alt_shift_toggle"; # Alt+Shift switches between layouts
  };

  services.printing.enable = true;

  # Auto-unlock gnome-keyring at GDM login so secret-service is available
  # to apps like VS Code, SSH agent, etc. even in non-GNOME sessions (Niri).
  security.pam.services.gdm.enableGnomeKeyring   = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
