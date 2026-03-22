# modules/nixos/locale.nix
{ ... }:

{
  time.timeZone      = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT    = "en_GB.UTF-8";
    LC_MONETARY       = "bn_BD";
    LC_NAME           = "en_GB.UTF-8";
    LC_NUMERIC        = "en_GB.UTF-8";
    LC_PAPER          = "en_GB.UTF-8";
    LC_TELEPHONE      = "bn_BD";
    LC_TIME           = "en_GB.UTF-8";
  };
}
