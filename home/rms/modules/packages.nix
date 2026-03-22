# home/rms/modules/packages.nix
{ pkgs, opencode, ... }:

{
  home.packages = with pkgs; [
    opencode
    firefox
    (vscode.override { commandLineArgs = "--ozone-platform=wayland --password-store=gnome-libsecret"; })
    btop
    ripgrep
    fd
    bat
    eza
    mpv
    gparted
    libreoffice
    evince
    nodejs
    uv              # Python package / environment manager
  ];
}
