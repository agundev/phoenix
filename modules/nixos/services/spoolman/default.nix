{
  config,
  lib,
  hostname,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.spoolman;
in
{
  options.phoenix.services.spoolman = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Spoolman server.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.spoolman = {
      isSystemUser = true;
      group = "spoolman";
    };
    users.groups.spoolman = { };

    systemd.services.spoolman = {
      description = "Spoolman server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p /var/lib/spoolman
        chown spoolman:spoolman /var/lib/spoolman
      '';
      
      environment = {
        SPOOLMAN_DIR_DATA = "/var/lib/spoolman";
        SPOOLMAN_DIR_BACKUPS = "/var/lib/spoolman/backups";
        SPOOLMAN_DIR_LOGS = "/var/lib/spoolman";
      };
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.spoolman} --host 0.0.0.0 --port 7912";
        Restart = "always";
        User = "spoolman";
        Group = "spoolman";
      };
    };

    systemd.tmpfiles.rules = [
      "L /var/lib/moonraker/config/klipper.cfg - - - - -"
    ];
  };
}
