{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  hardware = (import ./config.nix).hardware;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware.deviceTree = {
    enable = true;
    overlays = [
      {
        name = "disable-bt";
        dtsFile = ./disable-bt.dts;
      }
    ];
    filter = "bcm2710-rpi-3*";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault hardware.system;
}
