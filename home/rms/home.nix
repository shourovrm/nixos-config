# home/rms/home.nix
# User-level configuration managed by Home Manager.
{ config, pkgs, ... }:

{
  # ── Identity ──────────────────────────────────────────────────────────────
  home.username    = "rms";
  home.homeDirectory = "/home/rms";

  # Must match the Home Manager release you're using.
  home.stateVersion = "25.11";

  # ── User packages ─────────────────────────────────────────────────────────
  # Everything the user needs but that doesn't require system-level access.
  home.packages = with pkgs; [
    firefox
    # vscode
    (vscode.override { commandLineArgs = "--ozone-platform=wayland"; })  # optional, good for GNOME Wayland
    # neovim
    btop
    ripgrep
    fd
    bat          # better cat
    eza          # better ls

    # Office & document viewers
    libreoffice  # full office suite
    evince       # GNOME document/PDF viewer (integrates with GNOME)
  ];

  # ── Git ───────────────────────────────────────────────────────────────────
#  programs.git = {
#    enable    = true;
#    userName  = "Riad Mashrub Shourov";                        # CHANGE to your real name
#    userEmail = "shourovrm@gmail.com";            # CHANGE to your GitHub email
#    extraConfig = {
#      init.defaultBranch = "main";
#      pull.rebase        = false;
#      core.editor        = "nvim";
#    };
#  };

  programs.git = {
    enable    = true;
    settings = {
      user.name  = "rms";
      user.email = "you@example.com";
      init.defaultBranch = "main";
      pull.rebase        = false;
      core.editor        = "nvim";
    };
  };

  # ── Shell: Bash ───────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;
    shellAliases = {
      ll  = "eza -lah";
      cat = "bat";
      # Handy shortcuts for managing this config
      nixswitch = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      nixup     = "nix flake update ~/nixos-config && nixswitch";
    };
  };

  # ── Editor: Neovim (minimal) ──────────────────────────────────────────────
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    vimAlias      = true;
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
