{...}: {
  flake.modules.nixos.security = {
    security.apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    services.fail2ban.enable = true;

    networking.firewall = {
      enable = true;
      allowPing = true;
      logReversePathDrops = true;
      checkReversePath = "loose";
      allowedTCPPorts = [22];
      allowedUDPPorts = [22];
    };
  };
}