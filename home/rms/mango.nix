{ ... }:
{
	wayland.windowManager.mango = {
		enable = true;

		# Read config from the system mango-config file
		settings = builtins.readFile ../../mango-config/config.conf;

		autostart_sh = ''
			mako &
			/usr/libexec/polkit-gnome-authentication-agent-1 &
		'';
	};
}
