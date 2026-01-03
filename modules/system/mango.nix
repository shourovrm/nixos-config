{ config, pkgs, ... }:
{

	programs.mango.enable = true;

	services.seatd.enable = true;

	
	users.groups.seat = {};
	users.groups.video = {};
	users.users.rms.extraGroups = [ "seat" "video" ];

	programs.xwayland.enable = true;

	# OpenGL and graphics support
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [
			mesa
			libva
			libvdpau
			vulkan-loader
			vulkan-tools
		];
		extraPackages32 = with pkgs.pkgsi686Linux; [
			mesa
			libva
		];
	};

	environment.systemPackages = with pkgs; [
		wl-clipboard
		wayland-utils
		xwayland
		mesa-demos
	];
}
