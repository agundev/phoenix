{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs._1password;
in
{
  options.phoenix.programs._1password.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable 1Password configuration.";
  };

  config = lib.mkIf cfg.enable {
    programs._1password-gui.enable = true;
    programs._1password.enable = true;

    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          .zen-wrapped
        '';
        mode = "0755";
      };
    };
  };
}
