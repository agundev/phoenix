{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  	let pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
  	in {
      nixosConfigurations.advaiths-linux = pkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
        ];
    };
  };
}
