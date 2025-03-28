{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.desktop.fontconfig;
in
{
  options.phoenix.desktop.fontconfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Fontconfig.";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
  };
}
