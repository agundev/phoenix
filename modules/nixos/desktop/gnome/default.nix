{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.phoenix.desktop.gnome;
  mainUser = config.phoenix.users.mainUser;
in
{
  options.phoenix.desktop.gnome = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable GNOME Desktop Environment.";
  };

  config = lib.mkIf cfg {
    phoenix = {
      networking.networkmanager = true;
      audio.pipewire = true;
      desktop.cups = true;
    };

    services.xserver.enable = true;

    services.xserver.displayManager.gdm.enable = true;
    fileSystems."/run/gdm/.config/monitors.xml" = {
      device = "/home/${mainUser}/.config/monitors.xml";
      fsType = "none";
      options = [ "bind" ];
    };

    services.xserver.desktopManager.gnome.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
  };
}
