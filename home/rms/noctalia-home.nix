{ pkgs, ... }:
{
	programs.noctalia-shell = {
		enable = true;
		settings = {
			# Bar configuration
			bar = {
				density = "compact";
				position = "right";
				showCapsule = false;
				widgets = {
					left = [
						{
							id = "ControlCenter";
							useDistroLogo = true;
						}
						{
							id = "WiFi";
						}
						{
							id = "Bluetooth";
						}
					];
					center = [
						{
							hideUnoccupied = false;
							id = "Workspace";
							labelMode = "none";
						}
					];
					right = [
						{
							alwaysShowPercentage = false;
							id = "Battery";
							warningThreshold = 30;
						}
						{
							formatHorizontal = "HH:mm";
							formatVertical = "HH mm";
							id = "Clock";
							useMonospacedFont = true;
							usePrimaryColor = true;
						}
					];
				};
			};

			# Color scheme
			colorSchemes.predefinedScheme = "Monochrome";

			# General settings
			general = {
				avatarImage = "/home/rms/.face";
				radiusRatio = 0.2;
			};

			# Location settings (optional - customize to your location)
			location = {
				monthBeforeDay = true;
				name = "Your Location";
			};
		};
	};
}
