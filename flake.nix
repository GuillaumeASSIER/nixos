{
  description = "Guillaume NixOS configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-26.05-chilled/0.1";
    nixpkgs-unstable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    alejandra.url = "github:kamadorueda/alejandra";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:GuillaumeASSIER/nixos-hardware/thinkpad-t14s-gen6";
    };
    gassier-nix-pkgs.url = "github:GuillaumeASSIER/gassier-nix-pkgs";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);
}
