{...}: {
  flake.modules.nixos.ide = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      git
      lazygit
      opencode
    ];
  };
}