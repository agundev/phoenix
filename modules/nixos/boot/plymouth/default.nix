{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.boot.plymouth;
in
{
  options.phoenix.boot.plymouth.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Plymouth boot splash configuration.";
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = lib.mkDefault "bgrt";
    };

    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;
    boot.kernelParams = [
      "quiet"
      "udev.log_level=0"
    ];
  };
}
