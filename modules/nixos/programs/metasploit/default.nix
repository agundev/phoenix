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
  options.phoenix.programs.metasploit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Metasploit configuration.";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = config.phoenix.users.mainUser;
      description = "User under which Metasploit will run.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql.enable = true;
    users.users.${cfg.user}.extraGroups = [ "postgres" ];
    systemd.tmpfiles.rules = [
      "Z /run/postgresql 775 - - -"
    ];

    environment.systemPackages = with pkgs; [
      metasploit
    ];
  };
}
