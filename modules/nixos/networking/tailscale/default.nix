{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.networking.tailscale;
in
{
  options.phoenix.networking.tailscale.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Tailscale service.";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
