{
  config,
  lib,
  pkgs,  
  ...
}:

let
  cfg = config.phoenix.users.advaith;
in
{
  options.phoenix.users.advaith = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Advaith user account.";
  };

  config = lib.mkIf cfg {
    users.users.advaith = {
      isNormalUser = true;
      description = "Advaith Gundu";
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "nixos"
        "adbusers"
      ];
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
  };
}
