{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.programs.vesktop;
in
{
  options.phoenix.programs.vesktop = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Vesktop.";
  };

  config = lib.mkIf cfg {
    home.packages = [ pkgs.vesktop ];
  };
}
