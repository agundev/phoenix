{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.networking.tailscale;
in
{
  options.${namespace}.networking.tailscale = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Tailscale service.";
  };

  config = mkIf cfg {
    services.tailscale.enable = true;
  };
}
