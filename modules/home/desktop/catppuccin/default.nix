{
  config,
  lib,
  inputs,
  ...
}:

let
  cfgAll = config.phoenix.desktop.catppuccin.all;
  cfgGtk = config.phoenix.desktop.catppuccin.gtk;
in
{
  options.phoenix.desktop.catppuccin.all = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Catppuccin color scheme.";
  };

  options.phoenix.desktop.catppuccin.gtk = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Catppuccin theme for gtk.";
  };

  config = lib.mkMerge [
    (lib.mkIf cfgAll {
      catppuccin.enable = true;
    })
    (lib.mkIf cfgGtk {
      catppuccin.gtk.enable = true;
    })
  ];
}
