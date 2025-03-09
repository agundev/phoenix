{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.phoenix.desktop.printing;
in
{
  options.phoenix.desktop.printing = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable CUPS printing service.";
  };

  config = lib.mkIf cfg {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ mfc5860cnlpr mfc5860cncupswrapper ];
    };
  };
}
