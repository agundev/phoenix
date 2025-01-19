{ config, pkgs, ... }:

{
  users.users.advaith = {
    isNormalUser = true;
    description = "Advaith Gundu";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.advaith = import ./home.nix;
}
