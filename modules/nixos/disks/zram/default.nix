{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.disks.zram;
in
{
  options.phoenix.disks.zram.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable ZRAM swap configuration.";
  };

  config = lib.mkIf cfg.enable {
    zramSwap = {
      enable = true;
      memoryPercent = 75;
      priority = 100;
    };
  };
}
