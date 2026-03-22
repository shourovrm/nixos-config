# home/rms/modules/git.nix
{ ... }:

{
  programs.git = {
    enable    = true;
    userName  = "rms";
    userEmail = "you@example.com";   # CHANGE to your real email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = false;
      core.editor        = "nvim";
    };
  };
}
