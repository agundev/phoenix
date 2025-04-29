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
      group = "advaith";
      extraGroups = [
        "wheel"
        "dialout"
      ] ++ config.phoenix.users.extraGroups;
      shell = pkgs.zsh;
    };
    users.groups.advaith = {};

    nix.settings.trusted-users = [ "advaith" ];

    phoenix = {
      programs = {
        _1password.enable = true;
        adb.enable = true;
        metasploit.enable = true;
      };
      services = {
        input-remapper.enable = true;
      };
    };

    programs.zsh.enable = true;
    programs._1password-gui.polkitPolicyOwners = [ "advaith" ];
  };
}
