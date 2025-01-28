{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.desktop.flatpak;
in
{
  options.${namespace}.desktop.flatpak = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Flatpak configuration.";
  };

  config = mkIf cfg {
    services.flatpak.enable = true;
  };
}
