{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.disks.zram;
in
{
  options.${namespace}.disks.zram = lib.mkOption {
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
