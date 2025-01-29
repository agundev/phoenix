{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.nixos.permissions;
in
{
  options.${namespace}.system.permissions = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable custom permissions configuration.";
  };

  config = lib.mkIf cfg {
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
