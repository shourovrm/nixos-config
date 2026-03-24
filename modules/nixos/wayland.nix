# Shared system-side Wayland session wiring.
{ pkgs, ... }:

{
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
}