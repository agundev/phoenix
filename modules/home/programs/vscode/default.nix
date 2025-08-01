{
  config,
  lib,
  ...
}:

let
  cfg = config.phoenix.programs.vscode;
in
{
  options.phoenix.programs.vscode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Visual Studio Code editor.";
  };

  config =
    let
      firaCode = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      firaCodeMono = "'FiraCode Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
    in
    lib.mkIf cfg.enable {
      programs.vscode = {
        enable = true;
        profiles.default.userSettings = {
          # Stylix
          "editor.fontFamily" = lib.mkForce firaCode;
          "editor.inlayHints.fontFamily" = lib.mkForce firaCode;
          "editor.inlineSuggest.fontFamily" = lib.mkForce firaCode;
          "scm.inputFontFamily" = lib.mkForce firaCode;
          "debug.console.fontFamily" = lib.mkForce firaCode;
          "markdown.preview.fontFamily" = lib.mkForce firaCode;
          "chat.editor.fontFamily" = lib.mkForce firaCode;
          "terminal.integrated.fontFamily" = lib.mkForce firaCodeMono;

          # VSCode stuff
          "editor.tokenColorCustomizations" = { };

          # Theme settings
          "workbench.productIconTheme" = "fluent-icons";
          "workbench.iconTheme" = "file-icons";
          "editor.fontLigatures" = true;

          # VEX
          "vexrobotics.vexcode.Project.Home" = "/home/advaith/Documents/vex-vscode-projects";
          "vexrobotics.vexcode.Cpp.Sdk.Home" =
            "/home/advaith/.config/Code/User/globalStorage/vexrobotics.vexcode/sdk/cpp";
          "vexrobotics.vexcode.General.LogLevel" = 1;

          # Direnv
          "direnv.restart.automatic" = true;

          # C++
          "C_Cpp.clang_format_fallbackStyle" = "Mozilla";
        };
      };
    };
}
