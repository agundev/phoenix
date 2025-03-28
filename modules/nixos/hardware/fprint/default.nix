{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.phoenix.hardware.fprint;
  pamServices = config.security.pam.services;
in
{
  options.phoenix.hardware.fprint.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Fprintd fingerprint daemon.";
  };

  config = lib.mkIf cfg.enable {
    services.fprintd.enable = true;

    systemd.services.fprintd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };

    # TODO: add more robust solution without infrec
    security.pam.services = lib.genAttrs [ "sudo" "polkit-1" ] (name: {
      fprintAuth = false;
      rules.auth = {
        fprint-grosshack = {
          order = pamServices.${name}.rules.auth.unix.order - 10;
          control = "sufficient";
          modulePath = "${pkgs.libfprint-grosshack}/lib/security/pam_fprintd_grosshack.so";
        };
      };
    });
  };
}
