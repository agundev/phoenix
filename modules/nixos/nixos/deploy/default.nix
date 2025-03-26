{
  config,
  lib,
  inputs,
  system,
  ...
}:

let
  cfg = config.phoenix.nixos.deploy;
in
{
  options.phoenix.nixos.deploy = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable deployment configuration.";
  };

  config = lib.mkIf cfg {
    users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile ./key.pub) ];
  };
}
