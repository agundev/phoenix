{
  config,
  lib,

  ...
}:

let
  cfg = config.phoenix.desktop.flatpak;
in
{
  options.phoenix.desktop.flatpak.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Flatpak configuration.";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
