# home/rms/modules/packages.nix
{ pkgs, opencode, ... }:

{
  home.packages = with pkgs; [
    opencode
    firefox
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

    # ── LaTeX (offline, auto-installs missing packages on compile) ────────
    miktex          # MiKTeX TeX distribution with on-the-fly package install
    perl            # latexmk is a Perl script; required by MiKTeX's latexmk
  ];
}
