{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.zsh;
in
{
  options.phoenix.programs.zsh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable ZSH shell configuration.";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      antidote = {
        enable = true;
        plugins = [
          "Aloxaf/fzf-tab"
          "jeffreytse/zsh-vi-mode"
          "zsh-users/zsh-autosuggestions"
          "zdharma-continuum/fast-syntax-highlighting"
          "tom-doerr/zsh_codex"
        ];
      };
      initContent = builtins.concatStringsSep "\n" [
        ''
          # Create Python environment with openai and google-generativeai
          export ZSH_CODEX_PYTHON="${pkgs.python3.withPackages (ps: [ ps.openai ps.google-generativeai ps.groq ])}/bin/python"
        ''
        (builtins.readFile ./environment.zsh)
        (builtins.readFile ./functions.zsh)
        (builtins.concatStringsSep "\n" (
          map builtins.readFile (
            builtins.filter (name: lib.hasSuffix ".zsh" name) (lib.filesystem.listFilesRecursive ./configs)
          )
        ))
      ];
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf.enable = true;

    programs.eza = {
      enable = true;
      icons = "auto";
    };
  };
}
