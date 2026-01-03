{ config, pkgs, ... }:
{
	hardware.graphics.enable = true;

 	hardware.graphics.extraPackages = with pkgs; [
 		mesa
 	];

#	programs.xwayland.enable = true;
}
