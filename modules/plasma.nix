{...}: {
  flake.modules.nixos.plasma = {pkgs, ...}: {
    services = {
      flatpak.enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      printing.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      pulseaudio.enable = false;
    };

    environment.systemPackages = with pkgs; [
      kdePackages.kate
      kdePackages.konsole
      kdePackages.dolphin
      kdePackages.spectacle
    ];
  };
}
