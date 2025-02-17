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

  config = lib.mkIf cfg {
    programs.gnome-shell = {
      enable = true;
      extensions = [
        { package = pkgs.gnomeExtensions.dash-to-dock; }
        { package = pkgs.gnomeExtensions.blur-my-shell; }
        { package = pkgs.gnomeExtensions.valent; }
        { package = pkgs.gnomeExtensions.caffeine; }
        { package = pkgs.gnomeExtensions.burn-my-windows; }
        { package = pkgs.gnomeExtensions.just-perfection; }
        { package = pkgs.gnomeExtensions.lock-keys; }
        { package = pkgs.gnomeExtensions.open-bar; }
        { package = pkgs.gnomeExtensions.pano; }
        { package = pkgs.gnomeExtensions.removable-drive-menu; }
        { package = pkgs.gnomeExtensions.tiling-shell; }
        { package = pkgs.gnomeExtensions.tailscale-qs; }
        { package = pkgs.gnomeExtensions.rounded-window-corners-reborn; }
      ];
    };
  };
}
