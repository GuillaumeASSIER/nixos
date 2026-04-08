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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    alejandra,
    lanzaboote,
    sops-nix,
    hermes-agent,
  }: let
    username = "heap";
    hostname = "honor";
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      ${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit username hostname;
        };
        modules = [
          ./modules/honor/default.nix
          disko.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.default
          # hermes-agent.nixosModules.default
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
              extraSpecialArgs = {
                inherit username;
              };
              users.${username} = import ./modules/home/home.nix;
            };
          }
        ];
      };
    };

    formatter.${system} = alejandra.defaultPackage.${system};

    packages.${system} = {
      inherit (nixpkgs.legacyPackages.${system}) alejandra statix deadnix;
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
