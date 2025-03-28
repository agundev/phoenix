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
  options.phoenix.desktop.gnome.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable GNOME Desktop Environment.";
  };

  config = lib.mkIf cfg.enable {
    phoenix = {
      networking.networkmanager.enable = true;
      audio.pipewire.enable = true;
      desktop.printing.enable = true;
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
