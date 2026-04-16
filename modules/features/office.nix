{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libreoffice
    thunderbird
    obsidian
    pdfarranger
  ];
}