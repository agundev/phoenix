{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.boot.plymouth;
in
{
  options.${namespace}.boot.plymouth = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Plymouth boot splash configuration.";
  };

  config = mkIf cfg {
    boot.plymouth = {
      enable = true;
      theme = "bgrt";
    };

    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;
    boot.kernelParams = [
      "quiet"
      "udev.log_level=0"
    ];
  };
}
