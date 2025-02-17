{
  config,
  lib,
  inputs,  
  ...
}:

let
  cfg = config.phoenix.nixos.nixos-cli;
in
{
  options.phoenix.nixos.nixos-cli = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable nixos-cli program.";
  };

  config = lib.mkIf cfg {
    services.nixos-cli = {
      enable = true;
    };
  };
}
