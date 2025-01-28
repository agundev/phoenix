{ config, lib, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.desktop._1password;
in
{
  options.${namespace}.desktop._1password = mkOption {
    type = types.bool;
    default = false;
    description = "Enable 1Password configuration.";
  };

  config = mkIf cfg {
    programs._1password-gui.enable = true;
    programs._1password.enable = true;

    # Configure ssh-agent
    programs.ssh.extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
}
