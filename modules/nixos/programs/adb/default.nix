{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.programs.adb;
in
{
  options.${namespace}.programs.adb = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Android Debug Bridge (ADB) configuration.";
  };

  config = lib.mkIf cfg {
    programs.adb.enable = true;
  };
}
