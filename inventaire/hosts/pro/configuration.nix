{pkgs, ...}: {
  imports = [
    ../../../modules/features/core.nix
    ../../../modules/features/plasma.nix
    ../../../modules/features/ide.nix
    ../../../modules/features/browser.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    initrd.systemd.enable = true;
  };

  networking.hostName = "pro";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {enable = true;};

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    neovim
    wget
    tmux
    zellij
    direnv
    fzf
    ripgrep
    jq
    tree
    ncdu
    gdu
    htop
    btop

    # DevOps
    kubectl
    kubecolor
    kubectx
    k9s
    kubernetes-helm

    # Cloud/IaC
    opentofu
    terraform
    terraform-ls
    terragrunt
    ansible

    # Dev
    git
    lazygit
    pre-commit
    python3
    nodejs
    go
    rustc
    cargo

    # Containers
    podman
    podman-compose
    buildah
    virt-manager

    # Security
    pass
    sops
    gnupg

    # Network
    nmap
    mtr
    iperf3
    wireshark

    # Office
    libreoffice
    thunderbird
    pdfarranger
  ];

  programs = {
    git = {
      enable = true;
      config = {
        user.name = "guillaume";
        user.email = "guillaume@example.com";
        pull.rebase = false;
        init.defaultBranch = "main";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    mtr.enable = true;
    zsh.enable = true;
  };

  services.fwupd.enable = true;

  users.users.guillaume = {
    isNormalUser = true;
    group = "guillaume";
    extraGroups = ["wheel" "docker" "libvirtd"];
  };
  users.groups.guillaume = {};

  system.stateVersion = "25.11";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    download-buffer-size = 64 * 1024 * 1024;
    max-jobs = "auto";
    cores = 0;
    sandbox = true;
  };
}