# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  secrets,
  ...
}:
{
  phoenix = {
    boot = {
      systemd-boot.enable = false;
    };
    services = {
      mainsail = {
        enable = true;
      };
      moonraker-obico = {
        enable = true;
        server = "https://obico.${secrets.homeserver.domains.private}";
      };
      vinci-webcam.enable = true;
    };
  };
}
