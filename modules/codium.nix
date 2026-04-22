{...}: {
  flake.modules.homeManager.codium = {pkgs, ...}: {
    programs.vscode = {
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
          ms-python.python
          ms-python.vscode-pylance
          njpwerner.autodocstring
          yoavbls.pretty-ts-errors
          github.vscode-pull-request-github
          gitlab.gitlab-workflow
          github.github-vscode-theme
          vue.volar
        ];
        userSettings = {
          "workbench.colorTheme" = "GitHub Light";
          "git.enableSmartCommit" = true;
          "git.postCommitCommand" = "sync";
          "gitlab.duoChat.enabled" = false;
          "gitlab.duoCodeSuggestions.enabled" = false;
          "json.schemaDownload.trustedDomains" = {
            "https://developer.microsoft.com/json-schemas/" = true;
            "https://json-schema.org/" = true;
            "https://json.schemastore.org/" = true;
            "https://opencode.ai" = true;
            "https://raw.githubusercontent.com/devcontainers/spec/" = true;
            "https://raw.githubusercontent.com/microsoft/vscode/" = true;
            "https://schemastore.azurewebsites.net/" = true;
            "https://www.schemastore.org/" = true;
          };
        };
      };
    };
  };
}