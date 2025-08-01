{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.adb-daemon;
in
{
  options.phoenix.services.adb-daemon.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "An ADB daemon that allows connections from multiple users";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.adb = {
      description = "An ADB daemon that allows connections from multiple users";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.android-tools}/bin/adb -a server nodaemon";
        Restart = "always";
      };
    };
  };
}
