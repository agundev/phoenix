{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.phoenix.desktop.catppuccin;
in
{
  options.phoenix.desktop.catppuccin = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Catppuccin color scheme.";
  };

  config = lib.mkIf cfg {
    catppuccin.enable = true;
  };
}
