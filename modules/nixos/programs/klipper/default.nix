{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.programs.klipper;
  kamp = pkgs.fetchFromGitHub {
    owner = "kyleisah";
    repo = "Klipper-Adaptive-Meshing-Purging";
    rev = "main";
    sha256 = "sha256-05l1rXmjiI+wOj2vJQdMf/cwVUOyq5d21LZesSowuvc=";
  };
in
{
  options.phoenix.programs.klipper.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Klipper 3D Printer firmware.";
  };

  config = lib.mkIf cfg.enable {
    users.users.klipper = {
      isSystemUser = true;
      group = "klipper";
      extraGroups = [ "dialout" ];
    };
    users.groups.klipper = { };

    services.klipper = {
      enable = true;
      user = "klipper";
      group = "klipper";

      firmwares.vinci = {
        enable = true;
        configFile = ./vinci.ini;
      };

      configFile = pkgs.writeText "vinci.cfg" ''
        # This config file is managed by NixOS
        # Any changes made directly to this file will be lost

        [include ${kamp}/Configuration/KAMP_Settings.cfg]
        [include ${kamp}/Configuration/Adaptive_Meshing.cfg]
        [include ${kamp}/Configuration/Smart_Park.cfg]
        [include ${kamp}/Configuration/Line_Purge.cfg]

        ${builtins.readFile ./kamp.cfg}
        ${builtins.readFile ./vinci.cfg}
      '';
    };
  };
}
