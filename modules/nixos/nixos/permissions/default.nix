{ config, lib, ... }:

with lib;

let
  cfg = config.phoenix.system.permissions;
  mainUser = config.phoenix.users.mainUser;
in
{
  options.phoenix.system.permissions = mkOption {
    type = types.bool;
    default = true;
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

    users.users.${mainUser}.extraGroups = [ "nixos" ];
  };
}
