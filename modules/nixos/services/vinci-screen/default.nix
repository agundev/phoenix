{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.vinci-screen;
  src = pkgs.applyPatches {
    name = "DWIN_T5UIC1_LCD_E3S1";
    src = pkgs.fetchFromGitHub {
      owner = "RobRobM";
      repo = "DWIN_T5UIC1_LCD_E3S1";
      rev = "master";
      hash = "sha256-gyW5AkzG/F/V1p543/JrKN7ij5pAHy1QphrAjYFUWuQ="; # Replace with actual hash
    };
    patches = [
      (pkgs.writeText "options.patch" (
        builtins.replaceStrings
          [ "<apikey>" "<port>" ]
          [ cfg.apikey (toString config.services.moonraker.port) ]
          (builtins.readFile ./options.patch)
      ))
    ];
  };
  # I need to use python3Packages set because the python3 set does not include the overlay
  pythonEnv = pkgs.python3.withPackages (
    ps: with pkgs.python3Packages; [
      requests
      multitimer
      rpi-lgpio
      pyserial
    ]
  );
in
{
  options.phoenix.services.vinci-screen.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Allow the stock Ender 3 S1 LCD to be used with Klipper";
  };

  options.phoenix.services.vinci-screen.apikey = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "API key for Moonraker";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.vinci-screen = {
      description = "Allow the stock Ender 3 S1 LCD to be used with Klipper";
      wantedBy = [ "multi-user.target" ];
      after = [ "moonraker.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
        ExecStart = "${pythonEnv}/bin/python ${src}/run.py";
        Restart = "always";
        RuntimeDirectory = "vinci-screen";
      };
    };
  };
}
