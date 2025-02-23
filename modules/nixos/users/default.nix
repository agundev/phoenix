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
}
