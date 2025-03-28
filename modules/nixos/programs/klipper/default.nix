{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.klipper;
in
{
  options.phoenix.programs.klipper.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Klipper 3D Printer firmware.";
  };

  config = lib.mkIf cfg.enable {
    services.klipper = {
      enable = true;
      firmwares.vinci = {
        enable = true;
        configFile = ./vinci.ini;
      };
      configFile = ./vinci.cfg;
    };
  };
}
