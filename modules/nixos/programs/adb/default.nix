{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.adb;
in
{
  options.phoenix.programs.adb.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Android Debug Bridge (ADB) configuration.";
  };

  config = lib.mkIf cfg.enable {
    programs.adb.enable = true;

    phoenix.users.extraGroups = [ "adbusers" ];
  };
}
