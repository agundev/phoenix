{
  config,
  lib,
  namespace,
  inputs,
  ...
}:

let
  cfg = config.${namespace}.desktop.gnome;
in
{
  options.${namespace}.desktop.gnome = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable GNOME Desktop Environment.";
  };

  config = lib.mkIf cfg {
    ${namespace} = {
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
