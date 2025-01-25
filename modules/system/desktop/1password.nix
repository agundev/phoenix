{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs._1password-gui.enable = true;
  programs._1password.enable = true;

  # Configure ssh-agent
  programs.ssh.extraConfig = ''
      Host *
    	  IdentityAgent ~/.1password/agent.sock
  '';
}
