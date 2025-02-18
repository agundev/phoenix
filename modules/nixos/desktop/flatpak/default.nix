{
  config,
  lib,

  ...
}:

let
  cfg = config.phoenix.desktop.flatpak;
in
{
  options.phoenix.desktop.flatpak = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Flatpak configuration.";
  };

  config = lib.mkIf cfg {
    services.flatpak.enable = true;
  };
}
