{
  config,
  lib,
  hostname,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.mainsail;
  theme = pkgs.applyPatches {
    src = pkgs.fetchFromGitHub {
      owner = "bumbeng";
      repo = "mainsail_theme_mainsail";
      rev = "mainsail_theme_flat";
      sha256 = "sha256-+HXSpFbZQslaGeHpHwEtU5zJN2V7yky3I6zyjv3LUyc=";
    };
    patches = [ ./theme-blur.patch ];
  };
in
{
  options.phoenix.services.mainsail = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Mainsail klipper client.";
    };
    https = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Serve Mainsail over HTTPS.";
    };
    sslCertificate = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = "Path to the SSL certificate.";
    };
    sslCertificateKey = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = "Path to the SSL certificate key.";
    };
  };

  config = lib.mkIf cfg.enable {
    phoenix.programs.klipper.enable = true;
    phoenix.services.spoolman.enable = true;
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

        spoolman = {
          server = "http://localhost:7912";
        };

        announcements = {
          subscriptions = [ "mainsail" ];
        };
      };
    };

    users.users.moonraker.extraGroups = [ "klipper" ];
    systemd.tmpfiles.rules = [
      "d /var/lib/moonraker/config - moonraker moonraker - -"
      "L+ /var/lib/moonraker/config/.theme - - - - ${theme}"
      "L /var/lib/moonraker/config/klipper.cfg - - - - /var/lib/klipper/printer.cfg"
    ];

    services.mainsail = {
      enable = true;
      nginx = lib.mkIf cfg.https {
        addSSL = true;
        sslCertificate = cfg.sslCertificate;
        sslCertificateKey = cfg.sslCertificateKey;
      };
    };
    services.nginx.clientMaxBodySize = "100M";
  };
}
