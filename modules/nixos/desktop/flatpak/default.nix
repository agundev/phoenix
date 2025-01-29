{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.desktop.flatpak;
in
{
  options.${namespace}.desktop.flatpak = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Flatpak configuration.";
  };

  config = lib.mkIf cfg {
    services.flatpak.enable = true;
  };
}
