{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.networking.firewall;
in
{
  options.phoenix.networking.firewall.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Firewall configuration.";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.enable = false;
  };
}
