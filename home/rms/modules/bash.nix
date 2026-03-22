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

      # Activate the general Python venv if no other venv is already active
      if [ -z "$VIRTUAL_ENV" ] && [ -f "$HOME/.venv/general/bin/activate" ]; then
        source "$HOME/.venv/general/bin/activate"
      fi
    '';
  };
}
