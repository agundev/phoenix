{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.printing.cups;
in
{
  options.${namespace}.printing.cups = mkOption {
    type = types.bool;
    default = false;
    description = "Enable CUPS printing service.";
  };

  config = mkIf cfg {
    services.printing.enable = true;
  };
}
