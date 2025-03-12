{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.services.mainsail;
in
{
  options.phoenix.services.mainsail = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Mainsail klipper client.";
  };

  config = lib.mkIf cfg {
    phoenix.programs.klipper = true;
    services.moonraker.enable = true;
    
    services.mainsail.enable = true;
  };
}
