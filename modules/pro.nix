{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
in {
  configurations.nixos.pro = {
    module = {pkgs, ...}: {
      imports = with nixos;
        [
          core
          plasma
          ide
          browser
          secureboot
          k3s
          debug
          # pam-fix
          pro-hardware
          pro-disko
        ]
        ++ [
          inputs.disko.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen6
        ];

      nixpkgs.hostPlatform = "x86_64-linux";
      nixpkgs.config.allowUnfree = true;

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

      environment.pathsToLink = ["/share/zsh"];

      environment.systemPackages = with pkgs; [
        neovim
        wget
        tmux
        zellij
        direnv
        fzf
        ripgrep
        jq
        dig
        wireguard-tools

        kubectl
        kubecolor
        kubectx
        k9s
        kubernetes-helm
        fluxcd
        flux9s
        kubeseal

        opentofu
        terraform
        terraform-ls
        terragrunt
        ansible

        git
        lazygit
        pre-commit
        python3
        nodejs
        pnpm
        go
        go-task
        rustc
        cargo

        podman
        podman-compose
        buildah
        virt-manager
        act

        pass
        sops
        gnupg
        bluez

        libreoffice
        thunderbird
        pdfarranger
        element-desktop
        logseq
        rtk
        vlc
        brave
      ];

      programs = {
        git = {
          enable = true;
          config = {
            user.name = "GuillaumeAssier";
            user.email = config.guillaume.email;
            pull.rebase = true;
            init.defaultBranch = "main";
          };
        };
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        zsh.enable = true;
      };

      services.libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          clickMethod = "clickfinger";
        };
      };

      services.fwupd.enable = true;

      users.users.guillaume = {
        isNormalUser = true;
        group = "guillaume";
        extraGroups = ["wheel" "docker" "libvirtd"];
        shell = pkgs.zsh;
      };
      users.groups.guillaume = {};

      swapDevices = [
        {
          device = "/swapfile";
          size = 8192;
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

    homeManager.guillaume = {pkgs, ...}: {
      imports = with homeManager; [codium shell ssh];

      home.stateVersion = "25.11";

      xdg.configFile."opencode/opencode.json" = {
        source = let
          cfg = {
            "$schema" = "https://opencode.ai/config.json";
            provider = {
              openwebui = {
                npm = "@ai-sdk/openai-compatible";
                name = "Internal LLM  ";
                options = {
                  baseURL = config.openwebui.apiUrl;
                  apiKey = config.openwebui.apiKey;
                };
                models = {
                  "qwen3.6-35b-a3b" = {
                    name = "RTX.qwen3.6-35b-a3b";
                    limit = {
                      context = 32000;
                      output = 4096;
                    };
                  };
                };
              };
            };
          };
        in
          pkgs.writeText "opencode.json" (builtins.toJSON cfg);
      };

      home.packages = with pkgs; [
        gh
        tea
        thunderbird
        emote
        uv
        appflowy
      ];

      programs = {
        git = {
          enable = true;
          signing = {
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
            format = "ssh";
          };
          settings = {
            user.name = "GuillaumeAssier";
            user.email = config.guillaume.email;
            pull.rebase = true;
            init.defaultBranch = "main";
            gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          };
        };

        ssh.matchBlocks."${config.vates.gitHost}" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
          compression = true;
          kexAlgorithms = ["sntrup761x25519-sha512@openssh.com"];
          extraOptions = {
            HostKeyAlgorithms = "ssh-ed25519";
            PubkeyAcceptedAlgorithms = "ssh-ed25519";
          };
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
          ];
        };
      };
    };
  };
}
