{
  config,
  lib,
  hostname,
  ...
}:

let
  cfg = config.phoenix.services.input-remapper;
in
{
  options.phoenix.services.input-remapper.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable input-remapper daemon.";
  };

  config = lib.mkIf cfg.enable {
    services.input-remapper.enable = true;
  };
}
