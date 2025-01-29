{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.networking.networkmanager;
in
{
  options.${namespace}.networking.networkmanager = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NetworkManager service.";
  };

  config = lib.mkIf cfg {
    networking.networkmanager.enable = true;
  };
}
