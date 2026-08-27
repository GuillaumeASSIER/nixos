{...}: {
  flake.modules.nixos.core = {
    security.rtkit.enable = true;

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
      };
    };

    services.netbird.enable = true;

    programs.zsh.enable = true;
  };
}
