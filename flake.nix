{
  description = "A NixOS configuration that rose from the dead.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {    
    nixosConfigurations.euler = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./systems/euler
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
