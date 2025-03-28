{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.phoenix.programs._1password;
in
{
  options.phoenix.programs._1password.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable 1Password password manager.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;
        extraConfig = ''
          Host *
              IdentityAgent ~/.1password/agent.sock
        '';
      };

      git = {
        enable = true;
        extraConfig = {
          gpg = {
            format = "ssh";
          };
          "gpg \"ssh\"" = {
            program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
          };
          commit = {
            gpgsign = true;
          };
          user = {
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBY7Gr5L2ObD1KE3w8PXG0ilvYnPsPXgyIg3xIwQQZfW";
          };
        };
      };
    };
  };
}
