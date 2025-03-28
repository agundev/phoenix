{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.phoenix.desktop.stylix;
in
{
  options.phoenix.desktop.stylix.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Stylix theming engine.";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;

    stylix.image = ../../../../assets/wallpaper.png;

    stylix.fonts = rec {
      serif = sansSerif;

      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      monospace = {
        package = pkgs.adwaita-fonts;
        name = " Adwaita Mono";
      };
    };

    stylix.cursor = {
      package = pkgs.material-cursors;
      name = "material_light_cursors";
    };

    stylix.iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };

    stylix.polarity = "dark";
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
  };
}
