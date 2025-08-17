{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.users.root;
in
{
  options.phoenix.users.root = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable root user account.";
  };

  config = lib.mkIf cfg {
    users.users.root = {
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
  };
}
