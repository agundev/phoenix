{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.phoenix.desktop.gnome;
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

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}
