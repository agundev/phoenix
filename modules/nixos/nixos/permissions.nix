{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.system.permissions;
in
{
  options.${namespace}.system.permissions = mkOption {
    type = types.bool;
    default = false;
    description = "Enable custom permissions configuration.";
  };

  config = mkIf cfg {
    users.groups.nixos = { };
    systemd.tmpfiles.settings."99-nixos" = {
      "/etc/nixos".Z = {
        group = "nixos";
        mode = "0775";
        user = "root";
      };
    };
  };
}
