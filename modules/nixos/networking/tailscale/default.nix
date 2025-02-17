{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.networking.tailscale;
in
{
  options.phoenix.networking.tailscale = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Tailscale service.";
  };

  config = lib.mkIf cfg {
    services.tailscale.enable = true;
  };
}
