{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  hardware = import ./hardware.nix;
in
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault hardware.system;
}
