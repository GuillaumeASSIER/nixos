{...}: {
  flake.modules.nixos.office = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libreoffice
      thunderbird
      obsidian
      pdfarranger
    ];
  };
}