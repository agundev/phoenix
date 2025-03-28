{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.git;
in
{
  options.phoenix.programs.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Git version control.";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "geodic";
      userEmail = "geodic.github@proton.me";
    };
  };
}
