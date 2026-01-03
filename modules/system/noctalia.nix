{ pkgs, inputs, ... }:
{
	# Enable required services for Noctalia features
	networking.networkmanager.enable = true;
	hardware.bluetooth.enable = true;
	services.power-profiles-daemon.enable = true;
	services.upower.enable = true;

	# Install Noctalia package and dependencies
	environment.systemPackages = with pkgs; [
		inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
		gpu-screen-recorder
	];
}
