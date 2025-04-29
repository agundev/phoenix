{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.programs.metasploit;
in
{
  options.phoenix.programs.metasploit.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Metasploit configuration.";
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      settings.unix_socket_directories = "/tmp";
    };
    
    environment.systemPackages = with pkgs; [
      metasploit
    ];
  };
}
