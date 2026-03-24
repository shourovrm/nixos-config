# modules/nixos/desktop.nix
# Display manager (GDM) and fallback desktop (GNOME).
{ ... }:

{
  services.xserver.enable              = true;  # X server needed even for Wayland GDM
  services.displayManager.gdm.enable   = true;  # GNOME Display Manager (login screen)
  services.desktopManager.gnome.enable = true;  # full GNOME session available as fallback

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
