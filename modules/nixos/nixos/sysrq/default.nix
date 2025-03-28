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
  options.phoenix.nixos.sysrq.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable the SysRq key combination.";
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl."kernel.sysrq" = 1;
  };
}
