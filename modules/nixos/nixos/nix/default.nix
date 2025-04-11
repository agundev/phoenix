{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.nixos.nix;
in
{
  options.phoenix.nixos.nix.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable nix configuration.";
  };

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
