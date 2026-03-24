# modules/nixos/mangowc.nix
# Registers the mango Wayland session with GDM so it appears in the session
# picker (gear icon at login).  MangoWC is the nixpkgs package (v0.10.5) built
# from DreamMaoMao/mangowc; its binary is `mango` and the session is "mango".
{ pkgs, ... }:

{
  # Register the session — GDM picks up the .desktop file from the package's
  # share/wayland-sessions/ directory automatically.
  services.displayManager.sessionPackages = [ pkgs.mangowc ];

  # PolKit — already enabled by niri.nix but harmless to state here too.
  security.polkit.enable = true;

  # XDG portals for the mango session (screen sharing, file pickers, etc.).
  # wlr portal handles screen capture; gtk portal provides file pickers.
  # xdg-desktop-portal-gnome is already added by niri.nix; we only extend
  # extraPortals with wlr and add a per-session routing rule.
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.mango = { default = [ "wlr" "gtk" ]; };
  };
}
