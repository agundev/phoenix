{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.disks.zram;
in
{
  options.${namespace}.disks.zram = mkOption {
    type = types.bool;
    default = false;
    description = "Enable ZRAM swap configuration.";
  };

  config = mkIf cfg {
    zramSwap = {
      enable = true;
      memoryPercent = 75;
      priority = 100;
    };
  };
}