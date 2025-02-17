{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.direnv;
in
{
  options.phoenix.programs.direnv = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable direnv configuration.";
  };

  config = lib.mkIf cfg {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
