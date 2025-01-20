{ config, pkgs, inputs, ... }:

{  
  users.users.advaith = {
    isNormalUser = true;
    description = "Advaith Gundu";
    extraGroups = [ "networkmanager" "wheel" "dialout" "nixos"];
    shell = pkgs.zsh;
  };
  
  programs.zsh.enable = true;
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.advaith = import ./home.nix;
  home-manager.extraSpecialArgs = { inherit inputs; };
}
