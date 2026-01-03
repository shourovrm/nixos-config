{ ... }:
{

	wayland.windowManager.mango = {
		enable = true;

		settings = ''
		'';

		autostart_sh = ''
			mako &
			/usr/libexec/polkit-gnome-authentication-agent-1 &
		'';
	};
}
