{
  config,
  lib,
  hardware,
  ...
}:

let
  cfg = config.phoenix.disks.swap;
in
{
  options.phoenix.disks.swap.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable swap device configuration.";
  };

  config = lib.mkIf cfg.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = hardware.ram;
        priority = 10;
      }
    ];
  };
}
