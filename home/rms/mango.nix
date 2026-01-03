{ config, ... }:
let
	# Reference the system mango config file
	mangoConfigFile = ../../modules/system/mango-config/config.conf;
in
{

	wayland.windowManager.mango = {
		enable = true;

		# Don't generate config, let the system config handle it
		configFile = "${mangoConfigFile}";

		autostart_sh = ''
			mako &
			/usr/libexec/polkit-gnome-authentication-agent-1 &
		'';
	};
}
