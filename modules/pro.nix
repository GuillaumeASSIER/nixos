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
          desktop
          ide
          browser
          secureboot
          k3s
          debug
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
        xxd
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
        pyright
        nodejs
        pnpm
        typescript-language-server
        ansible-language-server
        go
        gopls
        go-task
        rustc
        cargo
        rust-analyzer

        docker-language-server
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
        opencode-desktop
        logseq
        rtk
        vlc
        brave
        playwright-driver
        playwright-driver.browsers
      ];

      environment.variables = {
        PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
        PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
        PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
      };

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
      imports = with homeManager; [codium shell ssh desktop];

      home.stateVersion = "26.05";

      xdg.configFile."opencode/opencode.json" = {
        source = let
          cfg = {
            "$schema" = "https://opencode.ai/config.json";
            provider = {
              litellm = {
                npm = "@ai-sdk/openai-compatible";
                name = "Internal LiteLLM";
                options = {
                  baseURL = config.openwebui.apiUrl;
                  apiKey = config.openwebui.apiKey;
                };
                models = {
                  "qwen3.6-35b-a3b" = {
                    name = "rtx-qwen3-6-35b-a3b";
                  };
                  "qwen3.6-27b" = {
                    name = "qwen3.6-27b";
                  };
                  "qwen3-coder" = {
                    name = "qwen3-coder";
                  };
                };
              };
            };
          };
        in
          pkgs.writeText "opencode.json" (builtins.toJSON cfg);
      };

      xdg.configFile."goose/goose.yaml" = {
        source = pkgs.writeText "goose.yaml" ''
          extensions:
            code_execution:
              enabled: false
              type: platform
              name: code_execution
              description: Goose will make extension calls through code execution, saving tokens
              display_name: Code Mode
              bundled: true
              available_tools: []
            extensionmanager:
              enabled: true
              type: platform
              name: Extension Manager
              description: Enable extension management tools for discovering, enabling, and disabling extensions
              display_name: Extension Manager
              bundled: true
              available_tools: []
            kubernetes-mcp-server:
              name: Kubernetes
              cmd: npx
              args:
              - -y
              - kubernetes-mcp-server@latest
              enabled: true
              type: stdio
              timeout: 300
              description: MCP server for interacting with Kubernetes clusters
            summon:
              enabled: true
              type: platform
              name: summon
              description: Load knowledge and delegate tasks to subagents
              display_name: Summon
              bundled: true
              available_tools: []
            tom:
              enabled: true
              type: platform
              name: tom
              description: Inject custom context into every turn via GOOSE_MOIM_MESSAGE_TEXT and GOOSE_MOIM_MESSAGE_FILE environment variables
              display_name: Top Of Mind
              bundled: true
              available_tools: []
            developer:
              enabled: true
              type: platform
              name: developer
              description: Write and edit files, and execute shell commands
              display_name: Developer
              bundled: true
              available_tools: []
            apps:
              enabled: true
              type: platform
              name: apps
              description: Create and manage custom Goose apps through chat. Apps are HTML/CSS/JavaScript and run in sandboxed windows.
              display_name: Apps
              bundled: true
              available_tools: []
            analyze:
              enabled: true
              type: platform
              name: analyze
              description: 'Analyze code structure with tree-sitter: directory overviews, file details, symbol call graphs'
              display_name: Analyze
              bundled: true
              available_tools: []
            todo:
              enabled: true
              type: platform
              name: todo
              description: Enable a todo list for goose so it can keep track of what it is doing
              display_name: Todo
              bundled: true
              available_tools: []
            kubernetes:
              command: npx
              args:
              - -y
              - kubernetes-mcp-server@latest
          GOOSE_TELEMETRY_ENABLED: false
          GOOSE_PROVIDER: litellm
          GOOSE_MODEL: rtx-qwen3-6-35b-a3b
          GOOSE_CLI_THEME: ansi
          LITELLM_HOST: https://litellm.vates.tech/
        '';
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

        ssh.settings."${config.vates.gitHost}" = {
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
          ];
        };
      };
    };
  };
}
