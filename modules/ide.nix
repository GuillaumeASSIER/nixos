{...}: {
  flake.modules.nixos.ide = {
    pkgs,
    inputs,
    ...
  }: {
    environment.systemPackages = with pkgs;
      [
        git
        gh
        lazygit
        goose-cli
        openssl
        inputs.gassier-nix-pkgs.packages.x86_64-linux.pi-coding-agent
      ]
      ++ [
        inputs.llm-agents.packages.x86_64-linux.opencode
      ];

    programs.git = {
      enable = true;
      config = {
        credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };
}
