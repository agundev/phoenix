{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.vinci-mobile-camera;
  serve = pkgs.writeShellScript "serve-vinci-mobile-camera" ''
    adb push ${pkgs.scrcpy}/share/scrcpy/scrcpy-server /data/local/tmp/scrcpy-server-manual.jar
    adb forward tcp:2375 localabstract:scrcpy
    adb shell CLASSPATH=/data/local/tmp/scrcpy-server-manual.jar \
      app_process / com.genymobile.scrcpy.Server ${pkgs.scrcpy.version} \
      video_source=camera camera_facing=back camera_size=1280x720 video_bit_rate=16000000 \
      tunnel_forward=true audio=false control=false cleanup=false \
      raw_stream=true
    ${pkgs.coreutils}/bin/sleep 5

    ${pkgs.ffmpeg}/bin/ffmpeg -fflags +nobuffer -flags low_delay -analyzeduration 0 -probesize 32 \
       -i tcp://localhost:2375 -c:v copy -f h264 tcp://0.0.0.0:2475?listen=1
  '';
in
{
  options.phoenix.services.vinci-mobile-camera.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "A cool and modern user interface for Klipper";
  };

  config = lib.mkIf cfg.enable {
    phoenix = {
      services.adb-daemon.enable = true;
    };

    systemd.services.vinci-mobile-camera = {
      description = "A Webcam service for Vinci";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.service" "adb.service" ];
      path = with pkgs; [ android-tools ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.android-tools}/bin/adb wait-for-usb-device";
        ExecStart = serve;
        TimeoutStartSec="infinity";
        Restart = "always";
      };
    };
  };
}
