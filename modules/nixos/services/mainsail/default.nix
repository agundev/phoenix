{
  config,
  lib,
  hostname,
  ...
}:

let
  cfg = config.phoenix.services.mainsail;
in
{
  options.phoenix.services.mainsail.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Mainsail klipper client.";
  };

  config = lib.mkIf cfg.enable {
    phoenix.programs.klipper.enable = true;
    services.moonraker = {
      enable = true;
      allowSystemControl = true;
      address = "0.0.0.0";

      settings = {
        authorization = {
          cors_domains = [
            "*://my.mainsail.xyz"
            "*://*.local"
            "*://*.lan"
            "*://${hostname}"
          ];

          trusted_clients = [
            "10.0.0.0/8"
            "127.0.0.0/8"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "100.111.0.0/16"
            "FE80::/10"
            "::1/128"
          ];
        };

        octoprint_compat = { };

        history = { };

        announcements = {
          subscriptions = [ "mainsail" ];
        };
      };
    };
    users.users.moonraker.extraGroups = [ "klipper" ];
    
    services.mainsail.enable = true;
  };
}
