{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.programs.adb;
in
{
  options.phoenix.programs.adb = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Android Debug Bridge (ADB) configuration.";
  };

  config = lib.mkIf cfg {
    programs.adb.enable = true;
  };
}
