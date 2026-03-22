# modules/nixos/niri.nix
# Registers niri as an available Wayland session in GDM.
# GNOME remains the default — pick session at login via the gear icon.
{ pkgs, ... }:

{
  # Enables niri, registers it as a Wayland session, sets up xdg portal
  programs.niri.enable = true;

  # Polkit — required for privilege escalation dialogs inside niri
  security.polkit.enable = true;

  # Provide the GNOME portal backend for screen sharing and file pickers
  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gnome ];
    config.niri   = { default = [ "gnome" "gtk" ]; };
  };
}
