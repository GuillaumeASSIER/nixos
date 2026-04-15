{pkgs, ...}: {
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gh
    discord
    thunderbird
    darktable
    orca-slicer
    emote
    rtk
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
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          shd101wyy.markdown-preview-enhanced
          jnoortheen.nix-ide
          redhat.vscode-yaml
          ms-azuretools.vscode-docker
          ms-kubernetes-tools.vscode-kubernetes-tools
          ms-vscode-remote.remote-containers
          kilocode.kilo-code
          ms-python.python
          ms-python.vscode-pylance
          njpwerner.autodocstring
          yoavbls.pretty-ts-errors
          github.vscode-pull-request-github
          gitlab.gitlab-workflow
          github.github-vscode-theme
        ];
        userSettings = {
          "workbench.colorTheme" = "GitHub Light";
          "git.autoFetch" = true;
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "git.postCommitCommand" = "sync";
        };
      };
    };
    git = {
      enable = true;
      settings = {
        user.name = "heap";
        user.email = "heap@example.com";
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