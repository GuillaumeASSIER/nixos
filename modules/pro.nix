{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
in {
  configurations.nixos.pro = {
    module = {
      pkgs,
      inputs,
      ...
    }: {
      imports = with nixos;
        [
          core
          desktop
          ide
          browser
          secureboot
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

      nixpkgs.overlays = [
        (final: prev: {
          k9s = inputs.nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system}.k9s;
        })
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

        apache-directory-studio
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

      networking.firewall = {
        enable = true;
        allowPing = true;
        allowedTCPPorts = [ 8000 8001 ];
        allowedUDPPorts = [];
      };

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

      system.stateVersion = "26.05";

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

    homeManager.guillaume = {
      pkgs,
      inputs,
      ...
    }: {
      imports = with homeManager; [codium shell ssh desktop];

      home.stateVersion = "26.05";

      xdg.configFile."opencode/opencode.json" = {
        source = let
          cfg = {
            "$schema" = "https://opencode.ai/config.json";
            autoupdate = false;
            provider = {
              litellm = {
                npm = "@ai-sdk/openai-compatible";
                name = "Internal LiteLLM";
                options = {
                  baseURL = config.litellm.apiUrl;
                  apiKey = config.litellm.apiKey;
                };
                models = {
                  "qwen3.6-35b-a3b" = {
                    name = "rtx-qwen3-6-35b-a3b";
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

      xdg.configFile."codex/config.toml" = {
        source = pkgs.writeText "config.toml" ''
          model = "qwen3-coder"
          model_provider = "proxy"
          approval_mode = "on-failure"
          sandbox = "workspace-write"

          [model_providers.proxy]
          name = "OpenAI using LLM proxy"
          base_url = "${config.litellm.apiUrl}"
          env_key = "LITELLM_API_KEY"
          wire_api = "responses"
        '';
      };

      xdg.configFile."codex/model_catalog.json" = {
        source = pkgs.writeText "model_catalog.json" (builtins.toJSON {
          models = [
            {
              slug = "qwen3-coder";
              display_name = "Qwen3 Coder";
              description = "Coding-optimized model served via the internal LiteLLM gateway.";
              default_reasoning_level = "medium";
              supported_reasoning_levels = [
                {effort = "low"; description = "Fast responses with lighter reasoning";}
                {effort = "medium"; description = "Balances speed and reasoning depth for everyday tasks";}
                {effort = "high"; description = "Greater reasoning depth for complex problems";}
                {effort = "xhigh"; description = "Extra high reasoning depth for complex problems";}
              ];
              shell_type = "shell_command";
              visibility = "list";
              supported_in_api = true;
              priority = 1;
              additional_speed_tiers = [];
              service_tiers = [];
              supports_reasoning_summaries = false;
              default_reasoning_summary = "auto";
              support_verbosity = false;
              default_verbosity = "medium";
              apply_patch_tool_type = "freeform";
              web_search_tool_type = "text";
              truncation_policy = {mode = "tokens"; limit = 10000;};
              supports_parallel_tool_calls = true;
              supports_image_detail_original = false;
              context_window = 32768;
              max_context_window = 32768;
              effective_context_window_percent = 95;
              experimental_supported_tools = [];
              input_modalities = ["text"];
              supports_search_tool = false;
              use_responses_lite = false;
            }
          ];
        });
      };

      home.packages = with pkgs; [
        gh
        tea
        thunderbird
        emote
        uv
        appflowy
        sqlite-interactive
        inputs.gassier-nix-pkgs.packages.x86_64-linux.godap
        inputs.gassier-nix-pkgs.packages.x86_64-linux.mimo-code
        inputs.gassier-nix-pkgs.packages.x86_64-linux.codex
        inputs.gassier-nix-pkgs.packages.x86_64-linux.opencode
        inputs.gassier-nix-pkgs.packages.x86_64-linux.pi-coding-agent
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
            package-version-server
          ];
        };
      };
    };
  };
}
