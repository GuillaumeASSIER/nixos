{...}: {
  flake.modules.nixos.k3s = {pkgs, ...}: {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = ["--write-kubeconfig-mode 600"];
    };

    networking.firewall = {
      allowedTCPPorts = [
        6443 # k3s API server
        10250 # kubelet API
      ];
      allowedUDPPorts = [
        8472 # flannel VXLAN (pod-to-pod, CNI-managed)
      ];
      extraCommands = ''
        # Allow pod-to-pod traffic via CNI interfaces
        iptables -A nixos-fw -i cni+ -j nixos-fw-accept
        iptables -A nixos-fw -o cni+ -j nixos-fw-accept
        iptables -A nixos-fw -i flannel+ -j nixos-fw-accept
        iptables -A nixos-fw -o flannel+ -j nixos-fw-accept
      '';
    };

    environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

    environment.systemPackages = with pkgs; [
      k3s
      kubernetes-helm
      k9s
    ];
  };
}
