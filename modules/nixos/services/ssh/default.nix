{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.services.ssh;
in
{
  options.phoenix.services.ssh = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable SSH server.";
  };

  config = lib.mkIf cfg {
    services.openssh.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile ./key.pub) ];
  };
}
