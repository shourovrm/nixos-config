{ inputs, pkgs, ... }:
{
	# import the official mango NixOS module 
	imports = [
		inputs.mango.nixosModules.mango
	];

	programs.mango.enable = true;

	services.seatd.enable = true;

	users.groups.video = {};

	programs.xwayland.enable = true;

	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			mesa
		];
	};

	environment.systemPackages = with pkgs; [
		wl-clipboard
		wayland-utils
		xwayland
	];
}
