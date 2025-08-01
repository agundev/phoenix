{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.hydroxide;
in
{
  options.phoenix.services.hydroxide.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable hydroxide service.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hydroxide ];

    systemd.user.services.hydroxide = {
      Unit = {
        Description = "Hydroxide ProtonMail IMAP/SMTP bridge";
        After = [ "network.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
