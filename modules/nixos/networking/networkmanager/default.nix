{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.networking.networkmanager;
in
{
  options.phoenix.networking.networkmanager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NetworkManager service.";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    phoenix.users.extraGroups = [ "networkmanager" ];
  };
}
