{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.networking.networkmanager;
in
{
  options.${namespace}.networking.networkmanager = mkOption {
    type = types.bool;
    default = false;
    description = "Enable NetworkManager service.";
  };

  config = mkIf cfg {
    networking.networkmanager.enable = true;
  };
}
