{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.networking.tailscale;
in
{
  options.${namespace}.networking.tailscale = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Tailscale service.";
  };

  config = lib.mkIf cfg {
    services.tailscale.enable = true;
  };
}
