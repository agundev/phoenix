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
  options.phoenix.desktop.gnome.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Gnome configuration.";
  };

  config = lib.mkIf cfg.enable {
    phoenix = {
      desktop = {
        fontconfig.enable = true;
      };
    };

    home.packages = with pkgs; [
      gnome-tweaks
      valent
    ];

    programs.gnome-shell = {
      enable = true;
      extensions =
        with pkgs.gnomeExtensions;
        builtins.map (pkg: { package = pkg; }) [
          dash-to-dock
          blur-my-shell
          valent
          caffeine
          burn-my-windows
          just-perfection
          lock-keys
          open-bar
          pano
          removable-drive-menu
          tiling-shell
          tailscale-qs
          rounded-window-corners-reborn
          quick-settings-tweaker
          bluetooth-battery-meter
          upower-battery
          top-bar-organizer
          color-picker
          search-light
          lineup
          brightness-control-using-ddcutil
          custom-hot-corners-extended
        ];
    };
  };
}
