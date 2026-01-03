{ pkgs, ... }:
{
	services.upower.enable = true;

	services.power-profiles-daemon.enable = true;

	environment.systemPackages = with pkgs; [
		brightnessctl
	];

	services.logind.settings = {
		Login = {
			HandleLidSwitch = "suspend";
			HandleLidSwitchDocked = "ignore";
		};
	};
}
