{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.networking.firewall;
in
{
  options.${namespace}.networking.firewall = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Firewall configuration.";
  };

  config = mkIf cfg {
    networking.firewall.enable = false;
  };
}
