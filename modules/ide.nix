{...}: {
  flake.modules.nixos.ide = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      git
      gh
      lazygit
      opencode
      goose-cli
      openssl
      pi-coding-agent
    ];

    programs.git = {
      enable = true;
      config = {
        credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };
}
