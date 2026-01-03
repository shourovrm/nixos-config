{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/system/base.nix
      ../../modules/system/audio.nix
      ../../modules/system/networking.nix
      ../../modules/system/power.nix
      ../../modules/system/filesystems.nix
      ../../modules/system/graphics.nix
    #  ../../modules/system/seatd.nix
     # ../../modules/system/polkit.nix
     # ../../modules/system/notifications.nix
     # ../../modules/system/launcher.nix
      ../../modules/system/mango.nix
      # ../../modules/system/boot-manager.nix
     # ../../modules/system/x11-temp.nix
    ];

  # systemd instead of grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "laptop"; # Define your hostname.


  users.users.rms = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;


  system.stateVersion = "25.11";

}

