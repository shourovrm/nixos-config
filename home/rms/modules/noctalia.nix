# home/rms/modules/noctalia.nix
# Noctalia shell — declarative config via its Home Manager module.
{ inputs, pkgs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        density     = "compact";
        position    = "top";
        showCapsule = false;

        widgets = {
          left = [
            { id = "ControlCenter"; useDistroLogo = true; }
            { id = "Network"; }
            { id = "Bluetooth"; }
          ];
          center = [
            { id = "Workspace"; hideUnoccupied = false; labelMode = "none"; }
          ];
          right = [
            { id = "Battery"; alwaysShowPercentage = true; warningThreshold = 20; }
            {
              id                = "Clock";
              formatHorizontal  = "HH:mm";
              formatVertical    = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor   = true;
            }
          ];
        };
      };

      colorSchemes.predefinedScheme = "Monochrome";

      general = {
        avatarImage = "/home/rms/.face";
        radiusRatio = 0.2;
      };

      location = {
        monthBeforeDay = false;
        name           = "Dhaka, Bangladesh";
      };
    };
  };
}
