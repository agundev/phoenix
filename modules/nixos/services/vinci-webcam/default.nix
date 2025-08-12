{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.vinci-webcam;
in
{
  options.phoenix.services.vinci-webcam.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "A webcam monitoring service for Vinci using camera-streamer";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.vinci-webcam = {
      description = "A webcam monitoring service for Vinci using camera-streamer";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.camera-streamer}/bin/camera-streamer \
            --camera-path=/dev/video0 \
            --camera-format=MJPG \
            --camera-width=1920 --camera-height=1080 \
            --camera-fps=30 \
            --camera-options=focusautomaticcontinuous=0 \
            --camera-options=focusabsolute=145 \
            --camera-snapshot.height=1080 \
            --camera-video.height=720 \
            --camera-video.options=h264_i_frame_period=15 \
            --camera-stream.height=480 \
            --camera-nbufs=2 \
            --http-listen=0.0.0.0 \
            --http-port=8080
        '';
        Restart = "always";

        DynamicUser = true;
        SupplementaryGroups = [ "video"];

        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
        CPUWeight = 20;
        AllowedCPUs = "1-2";
        MemoryMax = "250M";
      };
    };

    # services.go2rtc = {
    #   enable = true;
    #   settings.streams = {
    #     vinci_high = "ffmpeg:device?video=/dev/video0&input_format=mjpeg&video_size=1920x1080&framerate=30";
    #     vinci_medium = "ffmpeg:vinci_high#raw=-pix_fmt yuv420p#width=1280#video=h264#hardware";
    #   };
    # };
  };
}
