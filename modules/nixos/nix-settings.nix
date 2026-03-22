# modules/nixos/nix-settings.nix
{ ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };

  # Weekly GC — removes old generations, keeps the last 3 via configurationLimit
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-old";
  };

  # Keep exactly 3 generations in the GRUB boot menu
  boot.loader.grub.configurationLimit = 3;
}
