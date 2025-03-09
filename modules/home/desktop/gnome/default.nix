{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.desktop.gnome;
in
{
  options.phoenix.desktop.gnome = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Gnome configuration.";
  };

  config =
    lib.mkIf cfg {
      phoenix = {
        desktop = {
          fontconfig = true;
        };
      };

      home.packages = with pkgs; [
        gnome-tweaks
        valent
      ];

      programs.gnome-shell = {
        enable = true;
        extensions = with pkgs; builtins.map (pkg: { package = pkg; }) [
          gnomeExtensions.dash-to-dock
          gnomeExtensions.blur-my-shell
          gnomeExtensions.valent
          gnomeExtensions.caffeine
          gnomeExtensions.burn-my-windows
          gnomeExtensions.just-perfection
          gnomeExtensions.lock-keys
          gnomeExtensions.open-bar
          gnomeExtensions.pano
          gnomeExtensions.removable-drive-menu
          gnomeExtensions.tiling-shell
          gnomeExtensions.tailscale-qs
          gnomeExtensions.rounded-window-corners-reborn
          gnomeExtensions.quick-settings-tweaker
          gnomeExtensions.bluetooth-battery-meter
          gnomeExtensions.upower-battery
          gnomeExtensions.top-bar-organizer
          gnomeExtensions.color-picker
          gnomeExtensions.search-light
          gnomeExtensions.lineup
          gnomeExtensions.brightness-control-using-ddcutil
        ];
      };
    };
}
