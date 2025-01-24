{
  description = "A NixOS configuration that rose from the dead.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:geodic/nixos-hardware/fixes";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = builtins.attrNames (builtins.readDir ./systems);
    in {
      nixosConfigurations = builtins.listToAttrs (map (system: {
        name = system;
        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./systems/${system}
            {
              nixpkgs.config.allowUnfree = true;
            }
          ];
          specialArgs = { inherit inputs; };
        };
      }) systems);
    };
}

