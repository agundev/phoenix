{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.programs.git;
in
{
  options.${namespace}.programs.git = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Git version control.";
  };

  config = lib.mkIf cfg {
    programs.git = {
      enable = true;
      userName = "geodic";
      userEmail = "geodic.github@proton.me";
    };
  };
}
