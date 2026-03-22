# hosts/rms-laptop/configuration.nix
# Machine-specific settings only. Shared concerns live in modules/nixos/.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/niri.nix
    ../../modules/nixos/noctalia-system.nix
  ];

  # ── Machine identity ──────────────────────────────────────────────────────
  networking.hostName              = "rms-laptop";
  networking.networkmanager.enable = true;

  # ── Bootloader ────────────────────────────────────────────────────────────
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot/efi";
  boot.loader.grub.efiSupport          = true;
  boot.loader.grub.device              = "nodev";
  boot.loader.grub.useOSProber         = true;

  # ── User account ──────────────────────────────────────────────────────────
  users.users.rms = {
    isNormalUser = true;
    description  = "rms";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # ── System-wide packages ──────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [ git wget curl zathura ];

  nixpkgs.config.allowUnfree = true;

  # ── State version — do not change ─────────────────────────────────────────
  system.stateVersion = "25.11";
}
