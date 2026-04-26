{...}: {
  flake.modules.nixos.secureboot = {pkgs, ...}: {
    boot = {
      loader = {
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
        systemd-boot.configurationLimit = 4;
      };
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
