{ pkgs, ... }:
{
	home.username = "rms";
	home.homeDirectory = "/home/rms";

	home.stateVersion = "25.11";

	programs.git.enable = true;

	## for TTY session of mangorc
	home.sessionVariables = {
		XDG_SESSION_TYPE = "wayland";
		XDG_CURRENT_DESKTOP = "mangorc";
		XDG_SESSION_DESKTOP = "mangorc";

		MOZ_ENABLE_WAYLANG = "1";
		QT_QPA_PLATFORM = "wayland";
		SDL_VIDEODRIVER = "wayland";

		_JAVA_AWT_WM_NONREPARENTING = "1";
	};

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
		noctilia
	];

	programs.home-manager.enable = true;
}
