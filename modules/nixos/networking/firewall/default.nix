{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.networking.firewall;
in
{
  options.${namespace}.networking.firewall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Firewall configuration.";
  };

  config = lib.mkIf cfg {
    networking.firewall.enable = false;
  };
}
