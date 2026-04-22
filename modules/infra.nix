{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options = {
        module = lib.mkOption {
          type = lib.types.deferredModule;
        };

        homeManager = lib.mkOption {
          type = lib.types.attrsOf lib.types.deferredModule;
          default = {};
        };
      };
    });
    default = {};
  };

  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
      name: cfg:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            cfg.module
            inputs.home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users = lib.flip lib.mapAttrs cfg.homeManager (
                  username: hmCfg: hmCfg
                );
              };
            }
          ];
        }
    );

    formatter.x86_64-linux = inputs.alejandra.defaultPackage.x86_64-linux;

    packages.x86_64-linux = {
      inherit (inputs.nixpkgs.legacyPackages.x86_64-linux) alejandra statix deadnix;
      default = config.flake.packages.x86_64-linux.alejandra;
    };

    checks.x86_64-linux = lib.flip lib.mapAttrs config.flake.nixosConfigurations (
      name: nixos: nixos.config.system.build.toplevel
    );
  };

  config.flake.devShells.x86_64-linux.default =
    inputs.nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = [
        inputs.alejandra.defaultPackage.x86_64-linux
        inputs.nixpkgs.legacyPackages.x86_64-linux.statix
        inputs.nixpkgs.legacyPackages.x86_64-linux.deadnix
      ];
    };
}