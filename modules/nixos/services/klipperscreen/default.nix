{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.services.klipperscreen;
  adb = "${pkgs.android-tools}/bin/adb";
  prestart = pkgs.writeShellScript "klipperscreen-prestart" ''
    adb wait-for-usb-device

    adb forward tcp:6100 tcp:6000

    adb shell dumpsys nfc | grep 'mScreenState=' | grep OFF_LOCKED > /dev/null 2>&1
    if [ $? -lt 1 ]
    then
        echo "Screen is OFF and Locked. Turning screen on..."
        adb shell input keyevent 26
    fi

    adb shell dumpsys nfc | grep 'mScreenState=' | grep ON_LOCKED> /dev/null 2>&1
    if [ $? -lt 1 ]
    then
        echo "Screen is Locked. Unlocking..."
        adb shell input keyevent 82
    fi

    adb shell am start-activity x.org.server/.MainActivity
  '';
in
{
  options.phoenix.services.klipperscreen.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "A cool and modern user interface for Klipper";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.klipperscreen = {
      description = "A cool and modern user interface for Klipper";
      wantedBy = [ "multi-user.target" ];
      after = [ "moonraker.service" ];
      environment = {
        GDK_BACKEND = "x11";
        DISPLAY = ":100";
      };
      serviceConfig = {
        Type = "simple";
        ExecStartPre = prestart;
        ExecStart = "${pkgs.klipperscreen}/bin/KlipperScreen";
        Restart = "always";
        RuntimeDirectory = "klipperscreen";
      };
    };
  };
}
