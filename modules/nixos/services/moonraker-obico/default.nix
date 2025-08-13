{
  config,
  lib,
  hostname,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.moonraker-obico;
  janus = pkgs.janus-gateway;
  src = pkgs.applyPatches {
    src = pkgs.fetchFromGitHub {
      owner = "TheSpaghettiDetective";
      repo = "moonraker-obico";
      tag = "v2.1.0";
      hash = "sha256-sPJ9doPxyAj7HHKd/tU+GasfPvVpgT3jXgXwnoZlFI8=";
    };
    patches = [
      (pkgs.writeText "fix-debian.patch" (
        builtins.replaceStrings
          [ "<bin_path>" "<lib_path>" ]
          [ "${janus}/bin/janus" "${janus}/lib" ]
          (builtins.readFile ./fix-debian.patch)
      ))
    ];
  };
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    websocket-client
    bson
    backoff
    pathvalidate
    sentry-sdk
    requests
    sarge
    flask
    netaddr
    distro
  ]);
  prestart = pkgs.writeShellScript "moonraker-obico-prestart" ''
    cp -r ${src}/* $RUNTIME_DIRECTORY
    chmod -R 755 $RUNTIME_DIRECTORY
  '';
  configFile = pkgs.writeText "obico.cfg" ''
    [server]
    url = ${cfg.server}
    auth_token = b5a1d54513f1d4dcdfe5

    [moonraker]
    host = localhost
    port = 7125
    # api_key = <grab one or set trusted hosts in moonraker>

    [webcam]
    disable_video_streaming = False

    stream_mode = h264_copy
    h264_http_url = http://localhost:8080/video.mp4
    snapshot_url = http://localhost:8080/snapshot
    aspect_ratio_169 = True

    [logging]
    path = /var/lib/moonraker/logs/obico.log
    level = DEBUG

    [tunnel]
    # CAUTION: Don't modify the settings below unless you know what you are doing
    # dest_host = 127.0.0.1
    # dest_port = 80
    # dest_is_ssl = False
  '';
in
{
  options.phoenix.services.moonraker-obico = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable moonraker-obico klipper client.";
    };
    server = lib.mkOption {
      type = lib.types.str;
      default = "https://app.obico.io";
      description = "Obico server URL.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.moonraker-obico = {
      description = "Obico for Moonraker";
      wantedBy = [ "multi-user.target" ];
      after = [ "moonraker.service" ];

      path = with pkgs; [
        bash
        pythonEnv
        ffmpeg
      ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = prestart;
        ExecStart = "${pythonEnv}/bin/python -m moonraker_obico.app -c /var/lib/moonraker/config/obico.cfg";
        Restart = "always";
        RuntimeDirectory = "moonraker-obico";
        WorkingDirectory = "/run/moonraker-obico";
        User = "moonraker";
        Group = "moonraker";
      };
    };

    systemd.tmpfiles.rules = [
      "r /var/lib/moonraker/config/obico.cfg - - - - -"
      "C /var/lib/moonraker/config/obico.cfg 644 moonraker moonraker - ${configFile}"
      "z /var/lib/moonraker/logs/obico.log - moonraker moonraker - -"
    ];
  };
}
