{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.desktop.ddcci;
in
{
  options.phoenix.desktop.ddcci.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable DDCCI configuration.";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [
      "ddcci"
      "ddcci-backlight"
    ];
    hardware.i2c.enable = true;
    services.ddccontrol.enable = true;

    boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    environment.systemPackages = with pkgs; [ ddcutil ];

    phoenix.users.extraGroups = [ "i2c" ];

    services.udev.extraRules =
      let
        bash = "${pkgs.bash}/bin/bash";
        ddcciDev = "*[dD][dD][iI]*|*[dD][pP][bB]*";
        ddcciNode = "/sys/bus/i2c/devices/i2c-1/new_device";
      in
      ''
        SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="${ddcciDev}", RUN+="${bash} -c 'sleep 30; printf ddcci\ 0x37 > ${ddcciNode}'"
      '';

  };
}
