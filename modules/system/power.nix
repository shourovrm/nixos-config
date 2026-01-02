{ pkgs, ... }:
{
	services.upower.enable = true;

	services.power-profiles-daemon.enable = true;

	environment.systemPackages = with pkgs; [
		brightnessctl
	];

	# services.logind.settings.logind.HandleLidSwitch = "suspend";
	# services.logind.settings.Logind.HandleLidSwitchDocked = "ignore";
	services.logind = {
		lidSwitch = "suspend";
		lidSwitchDocked = "ignore";
	};
}
