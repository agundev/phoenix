{
  config,
  lib,
  
  ...
}:

let
  cfg = config.phoenix.programs.vscode;
in
{
  options.phoenix.programs.vscode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Visual Studio Code editor.";
  };

  config = lib.mkIf cfg {
    programs.vscode.enable = true;
  };
}
