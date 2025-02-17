{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.desktop.cups;
in
{
  options.phoenix.desktop.cups = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable CUPS printing service.";
  };

  config = lib.mkIf cfg {
    services.printing.enable = true;
  };
}
