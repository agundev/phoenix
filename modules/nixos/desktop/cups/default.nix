{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.printing.cups;
in
{
  options.${namespace}.printing.cups = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable CUPS printing service.";
  };

  config = lib.mkIf cfg {
    services.printing.enable = true;
  };
}
