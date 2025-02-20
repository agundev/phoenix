rec {
  description = "A NixOS configuration that rose from the dead.";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://watersucks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:geodic/nixos-hardware/fixes";

    nixos-cli.url = "github:water-sucks/nixos";
  };

  outputs =
    inputs@{
      flake-parts,
      home-manager,
      nixpkgs,
      nixpkgs-stable,
      nixos-cli,
      ...
    }:
    let
      mkLib =
        nixpkgs:
        nixpkgs.lib.extend (
          self: super:
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
            hostConfig = import ./hosts/${hostname};
            pkgs = if hostConfig.channel or "unstable" == "stable" then nixpkgs-stable else nixpkgs;
            system = hostConfig.system or "x86_64-linux";
          in
          pkgs.lib.nixosSystem {
            inherit system;
            modules = lib.flatten [
              ./hosts/${hostname}
              {
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = overlays;
              }
              nixos-cli.nixosModules.nixos-cli

              (builtins.filter (path: baseNameOf path == "default.nix") (
                pkgs.lib.filesystem.listFilesRecursive ./modules/nixos
              ))
            ];
            specialArgs = {
              inherit inputs;
              lib = mkLib pkgs;
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
                (builtins.filter (path: baseNameOf path == "default.nix") (
                  lib.filesystem.listFilesRecursive ./modules/home
                ))
              ];
              extraSpecialArgs = {
                inherit lib;
                inherit inputs;
              };
            }
          ) (builtins.readDir ./homes);
        };
    };
}
