{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.nixos.permissions;
in
{
  options.phoenix.nixos.permissions = lib.mkOption {
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
