{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.nixos.sysrq;
in
{
  options.phoenix.nixos.sysrq = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable the SysRq key combination.";
  };

  config = lib.mkIf cfg {
    boot.kernel.sysctl."kernel.sysrq" = 1;
  };
}
