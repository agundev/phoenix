{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.services.mainsail;
in
{
  options.phoenix.services.mainsail.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Mainsail klipper client.";
  };

  config = lib.mkIf cfg.enable {
    phoenix.programs.klipper.enable = true;
    services.moonraker.enable = true;
    
    services.mainsail.enable = true;
  };
}
