{ pkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable") {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # NixOS installation tools
    nixos-rebuild
    disko

    # Version control
    git
    lazygit

    # Utils
    tmux
  ];
}
