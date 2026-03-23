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
            # Current keyboard layout — click cycles to next layout; Super+Space also works
            { id = "KeyboardLayout"; }

            # System stats: RAM %, net speed, /root disk % shown inline.
            # compactMode = true  → mini-gauge icon only (no text, click to see values)
            # compactMode = false → displays the actual values as text in the bar
            {
              id                    = "SystemMonitor";
              compactMode           = false;  # show values inline, not just icon
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
            # Newsboat unread articles — text from newsboat-count script; click opens newsboat
            {
              id              = "CustomButton";
              icon            = "application-rss+xml";
              textCommand     = "newsboat-count";  # script outputs "  <n>" or ""
              textIntervalMs  = 300000;            # refresh every 5 minutes
              leftClickExec   = "newsboat-open";   # opens newsboat in foot terminal
              showIcon        = true;
            }
            # Dark / light mode toggle for Noctalia colour scheme
            { id = "DarkMode"; }
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
