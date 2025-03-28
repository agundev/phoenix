{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.services.ssh;
in
{
  options.phoenix.services.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable SSH server.";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile ./ci.pub) (builtins.readFile ./home.pub) ];
  };
}
