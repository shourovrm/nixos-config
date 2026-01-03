{ config, pkgs, ... }:
{
	# VirtualBox Guest Additions
	virtualisation.virtualbox.guest.enable = true;

	# Enable OpenGL and graphics rendering
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [
			mesa
			libva
			libvdpau
			vulkan-loader
		];
		extraPackages32 = with pkgs.pkgsi686Linux; [
			mesa
			libva
		];
	};

	# DRI and rendering
	environment.variables = {
		LIBGL_DRIVERS_PATH = "${pkgs.mesa}/lib/dri";
	};

	environment.systemPackages = with pkgs; [
		mesa-demos
		vulkan-tools
	];
}
