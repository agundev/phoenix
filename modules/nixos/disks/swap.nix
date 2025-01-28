{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.disks.swap;
in
{
  options.${namespace}.disks.swap = mkOption {
    type = types.bool;
    default = false;
    description = "Enable swap device configuration.";
  };

  config = mkIf cfg {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 8 * 1024;
        priority = 10;
      }
    ];
  };
}