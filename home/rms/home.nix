# home/rms/home.nix
# Entry point only — identity, stateVersion, and imports.
{ config, pkgs, inputs, opencode, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/git.nix
    ./modules/bash.nix
    ./modules/neovim.nix
    ./modules/niri.nix
    ./modules/noctalia.nix
  ];

  home.username      = "rms";
  home.homeDirectory = "/home/rms";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;
}
