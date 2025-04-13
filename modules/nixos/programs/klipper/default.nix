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
    users.users.klipper = {
      isSystemUser = true;
      group = "klipper";
      extraGroups = [ "dialout" ];
    };
    users.groups.klipper = { };
    
    services.klipper = {
      enable = true;
      user = "klipper";
      group = "klipper";

      firmwares.vinci = {
        enable = true;
        configFile = ./vinci.ini;
      };
      configFile = ./vinci.cfg;
    };
  };
}
