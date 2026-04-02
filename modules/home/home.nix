{pkgs, ...}: {
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gh
    tea
    glab
    discord
    thunderbird
  ];

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
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
      ];
    };
    git = {
      enable = true;
      settings = {
        user.name = "GuillaumeAssier";
        user.email = "sykursen@protonmail.com";
        pull.rebase = true;
        init.defaultBranch = "main";
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
