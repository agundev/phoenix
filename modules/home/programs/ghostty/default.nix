{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.ghostty;
in
{
  options.phoenix.programs.ghostty.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Ghostty terminal configuration.";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-family = lib.mkForce "FiraCode Nerd Font Mono";
      };
    };
  };
}
