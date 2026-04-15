{pkgs, ...}: {
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = ["--secrets-encryption"];
  };

  environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  environment.systemPackages = with pkgs; [
    k3s
    kubernetes-helm
    k9s
  ];
}