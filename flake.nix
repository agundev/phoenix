rec {
  description = "A NixOS configuration that rose from the dead.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:geodic/nixos-hardware/fixes";
  };

  outputs = inputs@{ flake-parts, nixpkgs, nixpkgs-stable, ... }:
    let 
      lib = nixpkgs.lib.extend (final: prev: {
        homeManagerModules = username: final.flatten [ 
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "25.05";
            programs.home-manager.enable = true;
          }
          ./homes/${username}
          (builtins.filter (path: baseNameOf path == "default.nix") (final.filesystem.listFilesRecursive ./modules/home))
        ];
      });
    in flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.home-manager.flakeModules.home-manager ];
      flake = {
        nixosConfigurations = builtins.mapAttrs
          (hostname: _: 
        let
          hostConfig = import ./hosts/${hostname};
            pkgs = if hostConfig.channel or "unstable" == "stable"
             then nixpkgs-stable
             else nixpkgs;
            system = hostConfig.system or "x86_64-linux";
        in pkgs.lib.nixosSystem {
          inherit system;
          modules = lib.flatten [
            ./hosts/${hostname}
            inputs.home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            (builtins.filter (path: baseNameOf path == "default.nix") (pkgs.lib.filesystem.listFilesRecursive ./modules/nixos))
          ];
          specialArgs = {
            inherit inputs;
            inherit lib;
          };
        })
          (builtins.readDir ./hosts);
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        legacyPackages.homeConfigurations = builtins.mapAttrs
          (username: _: inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = lib.homeManagerModules username;
          })
          (builtins.readDir ./homes);
      };
    };
}
