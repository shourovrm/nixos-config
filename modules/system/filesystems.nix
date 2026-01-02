{ pkgs, ... }:
{
	boot.supportedFilesystems = [ "ntfs" ]
	services.udisk2.enable = true;
	services.gvfs.enable = true;

	environment.systemPackages = with pkgs; [
		thunar
		thunar-volman
		ntfs-3g
	];
}
