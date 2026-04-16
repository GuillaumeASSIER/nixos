{ pkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable") {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # NixOS installation tools
    nixos-rebuild
    disko

    # Version control
    git
    git-lfs
    lazygit

    # Network tools
    openssh
    curl
    wget

    # Utils
    vim
    tmux

    # Cloud tools
    kubectl
    k9s
  ];

  # For passthrough
  GI_TYPELIB_PATH = "${pkgs.gtk3}/lib/gio/modules";
}
