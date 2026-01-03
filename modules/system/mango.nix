{ config, pkgs, ... }:
{

	programs.mango.enable = true;

	services.seatd.enable = true;

	
	users.groups.seat = {};
	users.groups.video = {};
	users.users.rms.extraGroups = [ "seat" "video" ];

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
