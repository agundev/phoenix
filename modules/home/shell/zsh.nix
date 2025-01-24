{config, pkgs, inputs, ...}:

{
  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      plugins = [
        "Aloxaf/fzf-tab"
        "jeffreytse/zsh-vi-mode"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };
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
}
