{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs._1password;
in
{
  options.phoenix.programs._1password = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable 1Password configuration.";
  };

  config = lib.mkIf cfg {
    programs._1password-gui.enable = true;
    programs._1password.enable = true;
  };
}
