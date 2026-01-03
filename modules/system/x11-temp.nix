{ config, pkgs, ... }:
{
	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "vboxvideo" ];
	
   #	services.xserver.displayManager.startx.enable = true;
	services.xserver.windowManager.i3.enable = true;
	services.xserver.windowManager.i3.package = pkgs.i3;

	services.xserver.libinput.enable = true;
	
	virtualisation.virtualbox.guest.enable = true;

	environment.systemPackages = with pkgs; [
		xorg.xinit
		xterm
		dmenu
	];
}
