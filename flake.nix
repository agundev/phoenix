rec {
  description = "A NixOS configuration that rose from the dead.";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://watersucks.cachix.org"
      "https://geodic.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
      "geodic.cachix.org-1:/VAwo3zaKEPYHybnBhqWh1aMSNqw9F9mXbJB57WdzfM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:geodic/nixos-hardware/fixes";

    nixos-cli.url = "github:water-sucks/nixos";

    stylix.url = "github:geodic/stylix/gdm-icon-theme";

    nixcord.url = "github:kaylorben/nixcord";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    inputs@{
      flake-parts,
      home-manager,
      nixpkgs,
      nixos-cli,
      stylix,
      nixcord,
      ...
    }:
    let
      mkLib =
        nixpkgs:
        nixpkgs.lib.extend (
          final: prev:
          {
            setNestedAttr =
              attr: value: attrset:
              builtins.mapAttrs (_: v: v // { ${attr} = value; }) attrset;
          }
          // home-manager.lib
        );
      lib = mkLib nixpkgs;

      overlays = builtins.map (overlayPath: import overlayPath) (
        builtins.filter (path: baseNameOf path == "default.nix") (
          nixpkgs.lib.filesystem.listFilesRecursive ./overlays
        )
      );
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.home-manager.flakeModules.home-manager ];
      flake = {
        nixosConfigurations = builtins.mapAttrs (
          hostname: _:
          let
            hostConfig = import ./hosts/${hostname}/hardware.nix;
            system = hostConfig.system or "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = lib.flatten [
              ./hosts/${hostname}
              {
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = overlays;
              }
              nixos-cli.nixosModules.nixos-cli
              stylix.nixosModules.stylix

              (builtins.filter (path: baseNameOf path == "default.nix") (
                nixpkgs.lib.filesystem.listFilesRecursive ./modules/nixos
              ))
            ];
            specialArgs = {
              inherit inputs lib system;
            };
          }
        ) (builtins.readDir ./hosts);
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = overlays;
          };

          legacyPackages.homeConfigurations = builtins.mapAttrs (
            username: _:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = lib.flatten [
                ./homes/${username}
                {
                  home.username = username;
                  home.homeDirectory = "/home/${username}";
                  home.stateVersion = "25.05";
                  programs.home-manager.enable = true;
                }
                stylix.homeManagerModules.stylix
                nixcord.homeManagerModules.nixcord

                (builtins.filter (path: baseNameOf path == "default.nix") (
                  lib.filesystem.listFilesRecursive ./modules/home
                ))
              ];
              extraSpecialArgs = {
                inherit inputs lib system;
              };
            }
          ) (builtins.readDir ./homes);
        };
    };
}
