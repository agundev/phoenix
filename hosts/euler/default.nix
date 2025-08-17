# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  phoenix = {
    hardware = {
      fprint.enable = true;
    };
    desktop = {
      gnome.enable = true;
      flatpak.enable = true;
      v4l2.enable = true;
      ddcci.enable = true;
    };
    users = {
      mainUser = "advaith";
      advaith = true;
    };
  };
}
