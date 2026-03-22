# home/rms/modules/neovim.nix
{ pkgs, ... }:

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    vimAlias      = true;
    withNodeJs    = true;   # required by copilot.lua

    # Tools made available on Neovim's PATH at runtime.
    # On NixOS, Mason cannot install binaries, so LSP servers live here.
    extraPackages = with pkgs; [
      # LSP servers
      clang-tools          # clangd  (C/C++/CUDA LSP + clang-format)
      pyright              # Python LSP

      # Formatters
      black                # Python formatter

      # Tree-sitter needs a C compiler to build parsers on first launch
      gcc
    ];
  };

  # Symlink the Lua config from this repo into ~/.config/nvim.
  # Uses recursive = true so lazy-lock.json can still be written by lazy.nvim.
  xdg.configFile."nvim" = {
    source    = ../nvim;
    recursive = true;
  };
}
