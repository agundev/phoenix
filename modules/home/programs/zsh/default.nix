{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.zsh;
  zshPlugin = name: rec {
    inherit name;
    src =
      let
        attr = if lib.hasPrefix "zsh" name then name else "zsh-${name}";
      in
      builtins.getAttr attr pkgs;
    file =
      let
        candidates = [
          "share/${name}/${name}.plugin.zsh"
          "share/${name}/${name}.zsh"
          "share/zsh/site-functions/${name}.plugin.zsh"
          "share/zsh/site-functions/${name}.zsh"
        ];
        exists = rel: builtins.pathExists (builtins.toPath "${src}/${rel}");
      in
      lib.findFirst exists (builtins.head candidates) candidates;
    completions = [ "share/zsh/site-functions" ];
  };
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
      plugins = map zshPlugin [
        "fzf-tab"
        "zsh-vi-mode"
        "zsh-autosuggestions"
        "fast-syntax-highlighting"
      ];
      initContent = builtins.concatStringsSep "\n" [
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
