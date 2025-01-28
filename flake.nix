{
  description = "A NixOS configuration that rose from the dead.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:geodic/nixos-hardware/fixes";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      snowfall-lib,
      ...
    }@inputs:
    snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
    };
}
