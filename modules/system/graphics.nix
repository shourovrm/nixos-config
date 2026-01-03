{ config, pkgs, ... }:
{
	# VirtualBox Guest Additions with auto-resize support
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

	# VirtualBox Guest Additions services for auto-resize
	systemd.services.vboxclient-video = {
		description = "VirtualBox Guest Additions - Video autosize";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		after = [ "graphical-session-pre.target" ];
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.virtualboxGuest}/bin/VBoxClient -displayvideoresize";
			Restart = "always";
			RestartSec = 5;
		};
	};

	environment.systemPackages = with pkgs; [
		mesa-demos
		vulkan-tools
		virtualboxGuest
	];
}

