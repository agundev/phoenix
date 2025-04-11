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
    boot = {
      systemd-boot.enable = true;
      systemd-initrd.enable = true;
      plymouth.enable = true;
    };
    hardware = {
      fprint.enable = true;
    };
    disks = {
      swap.enable = true;
      zram.enable = true;
    };
    desktop = {
      gnome.enable = true;
      flatpak.enable = true;
      v4l2.enable = true;
      ddcci.enable = true;
    };
    networking = {
      firewall.enable = true;
      tailscale.enable = true;
    };
    locale = {
      eastern.enable = true;
    };
    users = {
      mainUser = "advaith";
      advaith = true;
    };
  };
}
