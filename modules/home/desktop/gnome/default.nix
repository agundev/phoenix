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

  config = with pkgs; lib.mkIf cfg {
    programs.gnome-shell = {
      enable = true;
      extensions = builtins.map (pkg: { package = pkg; }) [
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
      ];
    };
  };
}
