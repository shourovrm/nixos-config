{ pkg, ... }:
{
	environment.systemPackages = with pkgs; [
		git
		neovim
		nano
		wget
		curl
		btop
	];

	services.dbus.enable = true;
	programs.dconf.enable = true;
}

