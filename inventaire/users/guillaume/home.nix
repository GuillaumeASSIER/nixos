{pkgs, ...}: {
  imports = [../../../modules/home/codium.nix];

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
              baseURL = builtins.getEnv "OPENWEBUI_API_URL";
              apiKey = builtins.getEnv "OPENWEBUI_API_KEY";
            };
            # models = {
            #   qwen3-6 = {
            #     name = "qwen3.6-35b-a3b";
            #   };
            # };
          };
        };
      };
    in pkgs.writeText "opencode.json" (builtins.toJSON cfg);
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
    tmux = {
      enable = true;
      mouse = true;
    };
    
    git = {
      enable = true;
      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
        format = "ssh";
      };
      settings = {
        user.name = "GuillaumeAssier";
        user.email = builtins.getEnv "GUILLAUME_EMAIL";
        pull.rebase = true;
        init.defaultBranch = "main";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "docker" "kubectl" "terraform"];
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
          compression = true;
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
          compression = true;
          kexAlgorithms = ["sntrup761x25519-sha512@openssh.com"];
          extraOptions = {
            HostKeyAlgorithms = "ssh-ed25519";
            PubkeyAcceptedAlgorithms = "ssh-ed25519";
          };
        };
        "${builtins.getEnv "VATES_GIT_HOST"}" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
          compression = true;
          kexAlgorithms = ["sntrup761x25519-sha512@openssh.com"];
          extraOptions = {
            HostKeyAlgorithms = "ssh-ed25519";
            PubkeyAcceptedAlgorithms = "ssh-ed25519";
          };
        };
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
}
