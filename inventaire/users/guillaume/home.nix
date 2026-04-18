{pkgs, ...}: {
  home.stateVersion = "25.11";

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
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          shd101wyy.markdown-preview-enhanced
          jnoortheen.nix-ide
          arrterian.nix-env-selector
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
          "git.enableSmartCommit" = true;
          "git.postCommitCommand" = "sync";
          "gitlab.duoCodeSuggestions.enabled" = false;
          "gitlab.duoChat.enabled" = false;
          "gitlab.duo.enabled" = false;
        };
      };
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
        user.email = "guillaume.assier@vates.tech";
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
        "git.vates.tech" = {
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
