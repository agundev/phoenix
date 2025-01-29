{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.desktop.cups;
in
{
  options.${namespace}.desktop.cups = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable CUPS printing service.";
  };

  config = lib.mkIf cfg {
    services.printing.enable = true;
  };
}
