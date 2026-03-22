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
            # System stats: RAM, network speed, /root disk usage %
            {
              id                    = "SystemMonitor";
              compactMode           = true;
              useMonospaceFont      = true;
              showCpuUsage          = false;
              showCpuTemp           = false;
              showMemoryUsage       = true;
              showMemoryAsPercent   = true;
              showNetworkStats      = true;
              showDiskUsage         = true;
              showDiskUsageAsPercent = true;
              diskPath              = "/";
            }
            # Volume — click opens audio mixer
            { id = "Volume"; displayMode = "always"; }
            { id = "Battery"; alwaysShowPercentage = true; warningThreshold = 20; }
            {
              id                = "Clock";
              formatHorizontal  = "HH:mm";
              formatVertical    = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor   = true;
            }
            # Session menu — shutdown / reboot / logout / screen off
            { id = "SessionMenu"; }
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
