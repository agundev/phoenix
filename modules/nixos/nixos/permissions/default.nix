{ config, lib, ... }:

let
  cfg = config.phoenix.system.permissions;
  mainUser = config.phoenix.users.mainUser;
in
{
  options.phoenix.system.permissions = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable custom permissions configuration.";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg {
      users.groups.nixos = { };
      systemd.tmpfiles.settings."99-nixos" = {
        "/etc/nixos".Z = {
          group = "nixos";
          mode = "0775";
          user = "root";
        };
      };
    })
    (lib.mkIf (mainUser != "") { users.users.${mainUser}.extraGroups = [ "nixos" ]; })
  ];
}
