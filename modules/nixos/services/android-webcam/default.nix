{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.android-webcam;
in
{
  options.phoenix.services.android-webcam.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "A cool and modern user interface for Klipper";
  };

  config = lib.mkIf cfg.enable {
    phoenix.desktop.v4l2 = {
      enable = true;
      devices = 1;
      video_nr = [ "100" ];
    };

    systemd.services.android-webcam = {
      description = "A cool and modern user interface for Klipper";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.android-tools}/bin/adb wait-for-usb-device";
        ExecStart = "${pkgs.scrcpy}/bin/scrcpy --video-source camera --camera-facing back -b 16M --v4l2-sink /dev/video100 --no-audio --no-window";
        Restart = "always";
      };
    };
  };
}
