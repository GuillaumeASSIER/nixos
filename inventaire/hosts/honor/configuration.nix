{pkgs, ...}: {
  imports = [
    ../../../modules/features/core.nix
    ../../../modules/features/desktop.nix
    ../../../modules/features/ide.nix
    ../../../modules/features/browser.nix
    ../../../modules/features/security.nix
    ../../../modules/features/journald.nix

    ../../../modules/features/k3s.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    initrd.systemd.enable = true;
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
    uv
    wget
    tmux
    zellij
    direnv
    fzf
    vhs
    sops
    mullvad-vpn
    proton-vpn
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
    nvtopPackages.intel
    inteltool
    igsc
    haskellPackages.intel-powermon

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
    nodejs
    bun
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
    element-desktop
    orca-slicer
  ];

  programs = {
    steam.enable = true;
    git = {
      enable = true;
      config = {
        user.name = "GuillaumeAssier";
        user.email = "sykursen@protonmail.com";
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
    shell = pkgs.zsh;
  };
  users.groups.heap = {};

  system.stateVersion = "25.11";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      download-buffer-size = 64 * 1024 * 1024;
      max-jobs = "auto";
      cores = 0;
      sandbox = true;
    };
  };
}
