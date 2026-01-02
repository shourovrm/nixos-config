{ pkgs, ... }:
{
	boot.supportedFilesystems = [ "ntfs" ];
	services.udisks2.enable = true;
	services.gvfs.enable = true;

	environment.systemPackages = with pkgs; [
		thunar
		thunar-volman
		ntfs3g
	];
}
