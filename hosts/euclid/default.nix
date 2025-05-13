# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  phoenix = {
    boot = {
      systemd-boot.enable = true;
      systemd-initrd.enable = true;
    };
    disks = {
      swap.enable = true;
      zram.enable = true;
    };
    networking = {
      firewall.enable = true;
      tailscale.enable = true;
      networkmanager.enable = true;
    };
    services = {
      mainsail = {
        enable = true;
        sslCertificate = ./cert.pem;
        sslCertificateKey = ./key.pem;
      };
      vinci-screen = {
        enable = true;
        apikey = "d1ed0ebe3a7641c287a7e507237e5915";
      };
    };
    locale = {
      eastern.enable = true;
    };
  };
}
