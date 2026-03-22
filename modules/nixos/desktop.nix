# modules/nixos/desktop.nix
{ ... }:

{
  services.xserver.enable              = true;
  services.displayManager.gdm.enable   = true;
  services.desktopManager.gnome.enable = true;

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
