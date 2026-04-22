{
  description = "Guillaume NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:GuillaumeASSIER/nixos-hardware/thinkpad-t14s-gen6";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    alejandra,
    lanzaboote,
    nixos-hardware,
  }: let
    system = "x86_64-linux";

    mkHost = {
      hostname,
      username,
      modules,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit username hostname;
        };
        modules =
          [
            {
              nixpkgs.hostPlatform = system;
              nixpkgs.config.allowUnfree = true;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {inherit username;};
                users.${username} = import ./inventaire/users/${username}/home.nix;
              };
            }
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = {
      honor = mkHost {
        hostname = "honor";
        username = "heap";
        modules = [
          ./inventaire/hosts/honor/default.nix
          disko.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
        ];
      };
      pro = mkHost {
        hostname = "pro";
        username = "guillaume";
        modules = [
          ./inventaire/hosts/pro/default.nix
          disko.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen6
        ];
      };
    };

    formatter.${system} = alejandra.defaultPackage.${system};

    packages.${system} = {
      inherit (nixpkgs.legacyPackages.${system}) alejandra statix deadnix;
      default = self.packages.${system}.alejandra;
    };

    devShells.${system} = {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = [
          alejandra.defaultPackage.${system}
          nixpkgs.legacyPackages.${system}.statix
          nixpkgs.legacyPackages.${system}.deadnix
        ];
      };
    };

    checks.${system} = {
      formatting = alejandra.defaultPackage.${system};
    };
  };
}
