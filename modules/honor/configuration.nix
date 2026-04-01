{pkgs, ...}: {
  imports = [
    ../features/core.nix
    ../features/desktop.nix
    ../features/ide.nix
    ../features/browser.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "honor";
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

  environment.systemPackages = with pkgs; [
    neovim
    wget
    tmux
    zellij
    direnv
    fzf
    vhs
    sops
    fastfetch
    act
    gh
    nix-index
    git-lfs

    # DevOps
    kubectl
    kubecolor
    kubectx
    k9s
    hubble

    # Network tools
    nmap
    ipcalc
    fping
    mtr
    openvpn

    # System utilities
    ncdu
    gdu
    tree

    # Search and text processing
    ripgrep
    jq

    # Development tools
    pre-commit
    automake
    autoconf

    # Programming languages
    python314
    python314Packages.pip
    nodePackages.npm
    go

    # Container tools
    podman
    podman-compose
    buildah

    # Cloud and infrastructure tools
    opentofu
    tofu-ls
    terraform
    terraform-ls
    terraform-docs
    terragrunt
    kubernetes-helm

    # Security tools
    pass

    # Virtualization
    virt-manager

    # Multimedia
    vlc
  ];

  programs = {
    git = {
      enable = true;
      config = {
        user.name = "heap";
        user.email = "heap@example.com";
        pull.rebase = false;
        init.defaultBranch = "main";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    mtr.enable = true;
  };

  services.fwupd.enable = true;

  users.users.heap = {
    isNormalUser = true;
    group = "heap";
    extraGroups = ["wheel" "docker" "libvirtd"];
  };
  users.groups.heap = {};

  system.stateVersion = "25.11";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    download-buffer-size = 64 * 1024 * 1024;
    max-jobs = "auto";
    cores = 0;
    sandbox = true;
  };
}
