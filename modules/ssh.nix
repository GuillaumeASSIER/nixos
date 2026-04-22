{...}: {
  flake.modules.homeManager.ssh = {
    programs.ssh = {
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
      };
    };
  };
}