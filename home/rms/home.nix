{ pkgs, ... }:
{
	home.username = "rms";
	home.homeDirectory = "/home/rms";

	home.stateVersion = "25.11";

	programs.git.enable = true;

	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;

	programs.kitty.enable = true;
	programs.foot.enable = true;

	home.packages = with pkgs; [
		firefox
		mpv
		newsboat
		lf
		zathura
		links2
		libreoffice
		discord
		zoom-us
		brave
		vscode
		python3
		rclone
		zathura
	];

	programs.home-manager.enable = true;
}
