{pkgs, ...}: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = ["--write-kubeconfig-mode 644" "--secrets-encryption"];
  };

  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  environment.systemPackages = with pkgs; [
    k3s
    kubernetes-helm
    k9s
  ];
}