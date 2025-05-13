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
      (pkgs.writeText "apikey.patch" ''
      diff --git a/run.py b/run.py
      index d5f3612..060f2d7 100755
      --- a/run.py
      +++ b/run.py
      @@ -4,7 +4,7 @@ from dwinlcd import DWIN_LCD
      encoder_Pins = (26, 19)
      button_Pin = 13
      LCD_COM_Port = '/dev/ttyAMA0'
      -API_Key = 'eb56bb488d3143708656f60074f70af0'
      +API_Key = '${cfg.apikey}'

      DWINLCD = DWIN_LCD(
              LCD_COM_Port,
      '')
      (pkgs.writeText "options.patch" ''
      diff --git a/printerInterface.py b/printerInterface.py
      index 69211b1..3953755 100644
      --- a/printerInterface.py
      +++ b/printerInterface.py
      @@ -250,10 +250,10 @@ class PrinterData:
              CORP_WEBSITE_E = "https://www.klipper3d.org/"

              def __init__(self, API_Key, URL='127.0.0.1'):
      -               self.op = MoonrakerSocket(URL, 80, API_Key)
      +               self.op = MoonrakerSocket(URL, ${toString config.services.moonraker.port}, API_Key)
                      self.status = None
                      print(self.op.base_address)
      -               self.ks = KlippySocket('/tmp/klippy_uds', callback=self.klippy_callback)
      +               self.ks = KlippySocket('/run/klipper/api', callback=self.klippy_callback)
                      subscribe = {
                              "id": 4001,
                              "method": "objects/subscribe",
      @@ -363,9 +363,9 @@ class PrinterData:
                              return
                      self.update_variable()
                      #alternative approach
      -               #full_version = self.getREST('/printer/info')['result']['software_version']
      -               #self.SHORT_BUILD_VERSION = '-'.join(full_version.split('-',2)[:2])
      -               self.SHORT_BUILD_VERSION = self.getREST('/machine/update/status?refresh=false')['result']['version_info']['klipper']['version']
      +               full_version = self.getREST('/printer/info')['result']['software_version']
      +               self.SHORT_BUILD_VERSION = '-'.join(full_version.split('-',2)[:2])
      +               #self.SHORT_BUILD_VERSION = self.getREST('/machine/update/status?refresh=false')['result']['version_info']['klipper']['version']

                      data = self.getREST('/printer/objects/query?toolhead')['result']['status']
                      toolhead = data['toolhead']
      '')
    ];
  };
  # I need to use python3Packages set because the python3 set does not include the overlay
  pythonEnv = pkgs.python3.withPackages (ps: with pkgs.python3Packages; [ requests multitimer rpi-lgpio pyserial ]);
in
{
  options.phoenix.services.vinci-screen.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
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
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart = "${pythonEnv}/bin/python ${src}/run.py";
        Restart = "always";
        WorkingDirectory = src;
      };
    };
  };
}
