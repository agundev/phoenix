{
  config,
  lib,
  inputs,
  hardware,
  ...
}:

let
  cfg = config.phoenix.nixos.certificates;
in
{
  options.phoenix.nixos.certificates.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Add rootCA to trusted certificate store.";
  };

  config = lib.mkIf cfg.enable {
    security.pki.certificateFiles = [ ../../../../assets/rootCA.pem ];
  };
}
