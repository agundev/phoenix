{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.disks.zram;
in
{
  options.phoenix.disks.zram = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable ZRAM swap configuration.";
  };

  config = lib.mkIf cfg {
    zramSwap = {
      enable = true;
      memoryPercent = 75;
      priority = 100;
    };
  };
}
