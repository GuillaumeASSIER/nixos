{...}: {
  security.rtkit.enable = true;
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  services.fail2ban = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      MaxAuthTries = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      X11Forwarding = false;
      AllowTcpForwarding = "no";
      AllowAgentForwarding = "no";
      PermitTunnel = "no";
      GatewayPorts = "no";
      Protocol = 2;
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    logReversePathDrops = true;
    checkReversePath = "loose";
    # Par défaut, bloquer tout le trafic entrant
    allowedTCPPorts = [22];
    allowedUDPPorts = [22];
  };

  programs.zsh.enable = true;
}
