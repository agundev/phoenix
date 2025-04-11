{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.boot.systemd-boot;
in
{
  options.phoenix.boot.systemd-boot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable systemd-boot bootloader.";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
