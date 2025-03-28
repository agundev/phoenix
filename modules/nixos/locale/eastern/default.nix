{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.locale.eastern;
in
{
  options.phoenix.locale.eastern.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Eastern locale configuration.";
  };

  config = lib.mkIf cfg.enable {
    # Set your time zone.
    time.timeZone = "America/New_York";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
