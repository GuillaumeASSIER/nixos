{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
in {
  configurations.nixos.honor = {
    module = {pkgs, ...}: {
      imports = with nixos;
        [
          core
          desktop
          ide
          browser
          security
          journald
          office
          k3s
          secureboot
          debug
          intel
          qemu
          honor-hardware
          honor-disko
        ]
        ++ [
          inputs.disko.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

      nixpkgs.hostPlatform = "x86_64-linux";
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [inputs.gassier-nix-pkgs.overlays.default];

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
      networking.firewall.allowedTCPPorts = [3000];

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

        kubectl
        kubecolor
        kubectx
        k9s
        hubble

        openvpn

        ripgrep
        jq

        pre-commit
        automake
        autoconf

        python314
        python314Packages.pip
        nodejs
        bun
        pnpm
        go

        podman
        podman-compose
        buildah

        opentofu
        tofu-ls
        terraform
        terraform-ls
        terraform-docs
        terragrunt
        kubernetes-helm

        pass

        virt-manager
        virt-viewer
        remmina

        vlc
        element-desktop
        orca-slicer
        qbittorrent
      ];

      programs = {
        steam.enable = true;
        git = {
          enable = true;
          config = {
            user.name = "GuillaumeAssier";
            user.email = config.heap.email;
            pull.rebase = false;
            init.defaultBranch = "main";
          };
        };
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };

      services.fwupd.enable = true;

      users.users.heap = {
        isNormalUser = true;
        group = "heap";
        extraGroups = ["wheel" "docker" "libvirtd"];
        shell = pkgs.zsh;
      };
      users.groups.heap = {};

      swapDevices = [
        {
          device = "/swapfile";
          size = 16384;
        }
      ];

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
    };

    homeManager.heap = {
      pkgs,
      inputs,
      ...
    }: {
      imports = with homeManager; [codium shell ssh desktop];

      home.stateVersion = "26.05";

      nixpkgs.overlays = [inputs.gassier-nix-pkgs.overlays.default];

      home.packages = with pkgs; [
        gh
        discord
        thunderbird
        darktable
        orca-slicer
        emote
        rtk
        appflowy
        mimo-code
        pi-coding-agent
        murmure
        torlink
      ];

      dconf = {
        enable = true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              appindicator.extensionUuid
              blur-my-shell.extensionUuid
            ];
          };
        };
      };

      programs = {
        git = {
          enable = true;
          settings = {
            user.name = "GuillaumeAssier";
            user.email = config.heap.email;
            pull.rebase = false;
            init.defaultBranch = "main";
          };
        };

        ssh.settings."gitea.com" = {
          IdentityFile = ["~/.ssh/id_ed25519"];
          AddKeysToAgent = "yes";
          Compression = true;
          KexAlgorithms = ["sntrup761x25519-sha512@openssh.com"];
          HostKeyAlgorithms = ["ssh-ed25519"];
          PubkeyAcceptedAlgorithms = ["ssh-ed25519"];
        };

        zed-editor = {
          enable = true;
          package = pkgs.zed-editor;
          extensions = [
            "nix"
            "toml"
            "dockerfile"
            "json"
            "aye"
            "opencode"
          ];
          userSettings = {
            features.copilot = false;
            telemetry.metrics = false;
            vim_mode = false;
            ui_font_size = 16;
            buffer_font_size = 16;
            theme = "Aye";
            format_on_save = "on";
            tab_size = 2;
            soft_tabs = true;
            prettier.allowed = true;
          };
          userKeymaps = [
            {
              context = "Workspace";
              bindings = {
                "ctrl-shift-t" = "workspace::NewTerminal";
              };
            }
          ];
          extraPackages = with pkgs; [
            nixd
            nil
            alejandra
            statix
            deadnix
            package-version-server
          ];
        };
      };
    };
  };
}
