{ config, pkgs, ... }:
{
	services.seatd.enable = true;

	users.users.rms.extraGroups = [ "seat" ];
}
