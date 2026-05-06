{...}: {
  flake.modules.homeManager.codium = {pkgs, ...}: {
    programs.vscodium = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          shd101wyy.markdown-preview-enhanced
          jnoortheen.nix-ide
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
          eamodio.gitlens
          mhutchie.git-graph
        ];
        userSettings = {
          "workbench.colorTheme" = "GitHub Light";
          "git.enableSmartCommit" = true;
          "git.postCommitCommand" = "sync";
          "git.confirmSync" = false;
          "git.fetchOnPull" = true;
          "git.pruneOnFetch" = true;
          "gitlab.duoChat.enabled" = false;
          "gitlab.duoCodeSuggestions.enabled" = false;
          "json.schemaDownload.trustedDomains" = [
            "https://developer.microsoft.com/json-schemas/"
            "https://json-schema.org/"
            "https://json.schemastore.org/"
            "https://opencode.ai"
            "https://raw.githubusercontent.com/devcontainers/spec/"
            "https://raw.githubusercontent.com/microsoft/vscode/"
            "https://schemastore.azurewebsites.net/"
            "https://www.schemastore.org/"
          ];
          "redhat.telemetry.enabled" = false;
        };
      };
    };
  };
}
