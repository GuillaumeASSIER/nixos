{...}: {
  flake.modules.nixos.secureboot = {pkgs, ...}: {
    boot = {
      loader.efi.canTouchEfiVariables = true;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          includeMicrosoftKeys = true;
          allowBrickingMyMachine = false;
          autoReboot = true;
        };
      };
    };

    environment.systemPackages = [pkgs.sbctl];
  };
}
