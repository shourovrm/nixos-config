{ pkgs, ... }:
{
	sound.enable = true;

	sercies.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32bit = true;
		wireplumber.enable = true;
	};
}
