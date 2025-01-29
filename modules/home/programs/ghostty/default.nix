{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.programs.ghostty;
in
{
  options.${namespace}.programs.ghostty = lib.mkOption {
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
      };
    };
  };
}
