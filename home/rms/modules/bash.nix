# home/rms/modules/bash.nix
{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll  = "eza -lah";
      cat = "bat";
      nixswitch = "sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop";
      nixup     = "nix flake update ~/nixos-config && nixswitch";
    };
    bashrcExtra = ''
      [ -f ~/.secrets/apirc ] && source ~/.secrets/apirc
    '';
  };
}
