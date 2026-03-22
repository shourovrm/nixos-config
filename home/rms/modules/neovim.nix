# home/rms/modules/neovim.nix
{ ... }:

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    vimAlias      = true;
  };
}
