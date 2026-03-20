# hosts/nixos/configuration.nix
# Machine-specific NixOS system configuration.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────────
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot/efi";
  boot.loader.grub.efiSupport          = true;
  boot.loader.grub.device              = "nodev";
  boot.loader.grub.useOSProber         = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName           = "nixos";
  networking.networkmanager.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────────────
  time.timeZone    = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT    = "en_GB.UTF-8";
    LC_MONETARY       = "en_GB.UTF-8";
    LC_NAME           = "en_GB.UTF-8";
    LC_NUMERIC        = "en_GB.UTF-8";
    LC_PAPER          = "en_GB.UTF-8";
    LC_TELEPHONE      = "en_GB.UTF-8";
    LC_TIME           = "en_GB.UTF-8";
  };

  # ── Desktop: GNOME ────────────────────────────────────────────────────────
  services.xserver.enable                            = true;
  # services.xserver.displayManager.gdm.enable        = true;
  # services.xserver.desktopManager.gnome.enable      = true;
  services.displayManager.gdm.enable   = true;   # was xserver.displayManager.gdm
  services.desktopManager.gnome.enable = true;   # was xserver.desktopManager.gnome
  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  # ── Sound: PipeWire ───────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable          = true;
    alsa.enable     = true;
    alsa.support32Bit = true;
    pulse.enable    = true;
  };

  # ── Printing ──────────────────────────────────────────────────────────────
  services.printing.enable = true;

  # ── User account ──────────────────────────────────────────────────────────
  users.users.rms = {
    isNormalUser = true;
    description  = "rms";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # ── System-wide packages ──────────────────────────────────────────────────
  # Only put things here that are truly system-wide or need root access.
  # User apps (editors, terminals, browsers…) belong in home/rms/home.nix.
  environment.systemPackages = with pkgs; [
    git      # needed to manage this very repo and for flake operations
    wget
    curl
    zathura  # lightweight keyboard-driven PDF/document viewer
  ];

  # ── Nix / Flakes settings ─────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };

  # Periodic garbage collection
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  # ── Unfree ────────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── State version — do not change ─────────────────────────────────────────
  # This is the NixOS release from which the defaults for stateful data were set.
  system.stateVersion = "25.11";
}
