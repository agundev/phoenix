{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.nixos.nix-ld;
in
{
  options.phoenix.nixos.nix-ld = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable nix-ld program.";
  };

  config = lib.mkIf cfg {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = import ./libs.nix pkgs;
  };
}
