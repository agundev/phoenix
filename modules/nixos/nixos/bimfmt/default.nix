{
  config,
  lib,
  inputs,
  system,
  ...
}:

let
  cfg = config.phoenix.nixos.binfmt;
in
{
  options.phoenix.nixos.binfmt = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable binfmt emulation.";
  };

  config = lib.mkIf cfg {
    boot.binfmt.emulatedSystems = lib.remove system [ "x86_64-linux" "aarch64-linux" ];
  };
}
