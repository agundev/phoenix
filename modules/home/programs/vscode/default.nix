{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.programs.vscode;
in
{
  options.${namespace}.programs.vscode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Visual Studio Code editor.";
  };

  config = lib.mkIf cfg {
    programs.vscode.enable = true;
  };
}
