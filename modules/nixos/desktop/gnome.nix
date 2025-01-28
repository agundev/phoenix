{ config, lib, namespace, inputs, ... }:

with lib;

let
  cfg = config.${namespace}.desktop.gnome;
in
{
  options.${namespace}.desktop.gnome = mkOption {
    type = types.bool;
    default = false;
    description = "Enable GNOME Desktop Environment.";
  };

  config = mkIf cfg {
    ${namespace}.networking.networkmanager = true;
    ${namespace}.audio.pipewire = true;
    ${namespace}.desktop.cups = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}