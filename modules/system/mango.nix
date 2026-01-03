{ config, pkgs, ... }:
{

	programs.mango.enable = true;

	services.seatd.enable = true;

	# Input device permissions for Wayland
	users.groups.input = {};
	users.groups.seat = {};
	users.groups.video = {};
	users.users.rms.extraGroups = [ "input" "seat" "video" ];

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

	# Libinput for input device handling
	services.libinput.enable = true;
	services.libinput.mouse.accelProfile = "flat";
	services.libinput.touchpad.accelProfile = "flat";

	environment.systemPackages = with pkgs; [
		wl-clipboard
		wayland-utils
		xwayland
		mesa-demos
		foot
    	wmenu
    	grim
    	slurp
    	swaybg
	];

	fonts.packages = with pkgs; [
    	nerd-fonts.jetbrains-mono
  	];
}
