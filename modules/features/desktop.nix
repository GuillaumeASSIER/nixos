{pkgs, ...}: {
  services = {
    flatpak.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.shell]
        enabled-extensions=['appindicator-support@rgcjonas.gmail.com','blur-my-shell@aunetx.de']
      '';
    };
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
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
    ];

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
}
