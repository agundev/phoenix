{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.desktop.fontconfig;
in
{
  options.${namespace}.desktop.fontconfig = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Fontconfig.";
  };

  config = lib.mkIf cfg {
    fonts.fontconfig.enable = true;
  };
}
