{pkgs, ...}: {
  imports = [../../../modules/home/codium.nix];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gh
    discord
    thunderbird
    darktable
    orca-slicer
    emote
    rtk
    appflowy
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
    tmux = {
      enable = true;
      mouse = true;
    };
    
    git = {
      enable = true;
      settings = {
        user.name = "GuillaumeAssier";
        user.email = builtins.getEnv "HEAP_EMAIL";
        pull.rebase = false;
        init.defaultBranch = "main";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = [ "history" "completion" "match_prev_cmd" ];
      };
      enableVteIntegration = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "docker" "kubectl" "terraform"];
      };
      history.size = 100000;
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
        "gitea.com" = {
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