{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.networking.networkmanager;
in
{
  options.phoenix.networking.networkmanager = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NetworkManager service.";
  };

  config = lib.mkIf cfg {
    networking.networkmanager.enable = true;
  };
}
