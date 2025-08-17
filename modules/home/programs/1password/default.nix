{
  config,
  lib,
  pkgs,
  secrets,
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
        };
        includes = [
          {
            condition = "gitdir:${lib.strings.toSentenceCase secrets.identities.public.name}/";
            contents = {
              user = {
                name = secrets.identities.public.name;
                email = secrets.identities.public.email;
                signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBY7Gr5L2ObD1KE3w8PXG0ilvYnPsPXgyIg3xIwQQZfW";
              };
            };
          }
          {
            condition = "gitdir:Personal/";
            contents = {
              user = {
                name = secrets.identities.personal.name;
                email = secrets.identities.personal.email;
                signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWtwI+dIN//xWbUbDcO3o0EnqkMnlmIegO01bYHHhgb";
              };
            };
          }
        ];
      };
    };
  };
}
