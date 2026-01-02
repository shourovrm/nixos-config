{ pkgs, ... }:
{
	services.upower.enable = true;

	services.power-profiles-daemon.enable = true;

	environment.systemPackages = with pkgs; [
		brightnessctl
	];

	services.logind.lidSwitch = "suspend";
}
