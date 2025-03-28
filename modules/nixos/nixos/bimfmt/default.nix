{
  config,
  lib,
  inputs,
  hardware,
  ...
}:

let
  cfg = config.phoenix.nixos.binfmt;
in
{
  options.phoenix.nixos.binfmt.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable binfmt emulation.";
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.emulatedSystems = lib.remove hardware.system [ "x86_64-linux" "aarch64-linux" ];
  };
}
