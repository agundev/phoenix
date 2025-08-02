{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.adb-daemon;
  exec = pkgs.writeShellScript "adb-server" ''
    ${pkgs.android-tools}/bin/adb -a server nodaemon &

    until ${pkgs.netcat}/bin/nc -z localhost 5037; do
      sleep 0.5
    done

    systemd-notify --ready

    wait
  '';
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
        Type = "notify";
        NotifyAccess = "all";
        ExecStartPre = "${pkgs.android-tools}/bin/adb kill-server";
        ExecStart = "${pkgs.android-tools}/bin/adb -a server nodaemon";
        Restart = "always";
      };
    };
  };
}
