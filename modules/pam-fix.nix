{...}: {
  flake.modules.nixos.pam-fix = {
    disabledModules = ["security/pam.nix"];
    imports = [../patches/pam.nix];
  };
}