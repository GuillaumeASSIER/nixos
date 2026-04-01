{pkgs, ...}: {
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gh
    tea
    glab
  ];

  programs = {
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
  };
}
