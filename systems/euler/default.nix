# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-intel-tiger-lake
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.home-manager.nixosModules.home-manager
    (inputs.self + /users/advaith)
    (inputs.self + /modules/system/boot/plymouth.nix)
    (inputs.self + /modules/system/nixos/nix-ld.nix)
    (inputs.self + /modules/system/nixos/permissions.nix)
    (inputs.self + /modules/system/desktop/gnome.nix)
    (inputs.self + /modules/system/desktop/flatpak.nix)
    (inputs.self + /modules/system/desktop/1password.nix)
    (inputs.self + /modules/system/networking/firewall.nix)
    (inputs.self + /modules/system/networking/tailscale.nix)
    (inputs.self + /modules/system/locale/eastern.nix)
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "euler";
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
