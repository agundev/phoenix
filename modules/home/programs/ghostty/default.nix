{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.ghostty;
in
{
  options.phoenix.programs.ghostty = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Ghostty terminal configuration.";
  };

  config = lib.mkIf cfg {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        # Font configuration
        font-family = "FiraCode Nerd Font Mono";
        theme = "Adwaita Dark";
      };
    };
  };
}
