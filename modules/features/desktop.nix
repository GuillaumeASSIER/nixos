{...}: {
  services = {
    flatpak.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false;
  };
}
