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
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
  ];

  # Bootloader.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "euclid";

  phoenix = {
    disks = {
      swap = true;
      zram = true;
    };
    networking = {
      firewall = true;
      tailscale = true;
      networkmanager = true;
    };
    services = {
      mainsail = true;
    };
    locale = {
      eastern = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
