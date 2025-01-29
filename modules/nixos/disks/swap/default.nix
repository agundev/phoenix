{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.disks.swap;
in
{
  options.${namespace}.disks.swap = lib.mkOption {
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
