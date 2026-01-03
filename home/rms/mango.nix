{ inputs, ... }:
{
	imports = [
		inputs.mango.hmModules.mango
	];

	wayland.windowManager.mango = {
		enable = true;

		settings = ''
			mod = SUPER
			terminal = kitty
		'';

		autostart_sh = ''
			mako &
			/usr/libexec/polkit-gnome-authentication-agent-1 &
		'';
	};
}
