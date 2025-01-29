{
  config,
  lib,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.programs._1password;
in
{
  options.${namespace}.programs._1password = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable 1Password configuration.";
  };

  config = lib.mkIf cfg {
    programs._1password-gui.enable = true;
    programs._1password.enable = true;

    # Configure ssh-agent
    programs.ssh.extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
}
