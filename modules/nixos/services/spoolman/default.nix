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
      home = "/var/lib/spoolman";
      createHome = true;
      group = "spoolman";
    };
    users.groups.spoolman = { };

    systemd.services.spoolman = {
      description = "Spoolman server";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.spoolman}";
        Restart = "always";
        User = "spoolman";
        Group = "spoolman";
      };
    };
  };
}
