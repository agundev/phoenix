{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.users.mainUser;
in
{
  options.phoenix.users.mainUser = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Set main user for system.";
  };

  options.phoenix.users.extraGroups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Set extra groups for all users.";
  };
}
