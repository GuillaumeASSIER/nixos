{...}: {
  flake.modules.nixos.test99 = {
    nixpkgs.config.allowUnfree = true;
  };
}
