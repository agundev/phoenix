{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.desktop.v4l2;
in
{
  options.phoenix.desktop.v4l2 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable V4L2 configuration.";
    };
    devices = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Number of loopback devices to create.";
    };
    video_nr = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "The video device number(s) to use for the loopback devices.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=${toString cfg.devices} video_nr=${lib.concatStringsSep "," cfg.video_nr}
    '';

    environment.systemPackages = with pkgs; [
      config.boot.kernelPackages.v4l2loopback.bin
      v4l-utils
    ];
  };
}
