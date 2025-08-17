{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.boot.systemd-initrd;
in
{
  options.phoenix.boot.systemd-initrd.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable systemd initramfs.";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.enable = true;
  };
}
