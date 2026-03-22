# modules/nixos/noctalia-system.nix
# System-level services required by the Noctalia shell widgets.
{ ... }:

{
  # Bluetooth widget
  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  # Power profile widget (conflicts with services.tuned — use one or the other)
  services.power-profiles-daemon.enable = true;

  # Battery widget
  services.upower.enable = true;
}
