{ ... }:
{

	wayland.windowManager.mango = {
		enable = true;

		settings = ''
			# Input device configuration
			input {
				keyboard {
					repeat_delay 500
					repeat_rate 25
					xkb_layout us
					xkb_options caps:escape
				}
				
				mouse {
					accel_profile flat
					sensitivity 0.0
				}
				
				touchpad {
					accel_profile flat
					tap enabled
					drag enabled
				}
			}
		'';

		autostart_sh = ''
			mako &
			/usr/libexec/polkit-gnome-authentication-agent-1 &
		'';
	};
}
