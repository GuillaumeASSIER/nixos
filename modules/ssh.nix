{...}: {
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          IdentityFile = ["~/.ssh/id_ed25519"];
          AddKeysToAgent = "yes";
          Compression = true;
        };
        "github.com" = {
          IdentityFile = ["~/.ssh/id_ed25519"];
          AddKeysToAgent = "yes";
          Compression = true;
          KexAlgorithms = ["sntrup761x25519-sha512@openssh.com"];
          HostKeyAlgorithms = ["ssh-ed25519"];
          PubkeyAcceptedAlgorithms = ["ssh-ed25519"];
        };
      };
    };
  };
}
