{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.services.docker;
in
{
  options.phoenix.services.docker.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the docker contanerization software.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
      };
    };

    phoenix.users.extraGroups = [ "docker" ];
  };
}
