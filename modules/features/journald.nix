{...}: {
  services.journald.extraConfig = ''
    SystemMaxUse=5G
  '';
}