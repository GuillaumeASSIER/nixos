{...}: {
  flake.modules.nixos.journald = {
    services.journald.extraConfig = ''
      SystemMaxUse=5G
    '';
  };
}