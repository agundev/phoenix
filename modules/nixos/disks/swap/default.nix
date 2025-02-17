{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.disks.swap;
in
{
  options.phoenix.disks.swap = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable swap device configuration.";
  };

  config = lib.mkIf cfg {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 8 * 1024;
        priority = 10;
      }
    ];
  };
}
