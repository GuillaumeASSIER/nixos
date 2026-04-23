{...}: {
  flake.modules.homeManager.shell = {
    programs = {
      tmux = {
        enable = true;
        mouse = true;
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
          strategy = ["history" "completion" "match_prev_cmd"];
        };
        enableVteIntegration = true;
        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = ["git" "docker" "kubectl" "terraform"];
        };
        history.size = 100000;
      };
    };
  };
}