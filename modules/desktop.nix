{...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services = {
      flatpak.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.shell]
          enabled-extensions=['appindicator-support@rgcjonas.gmail.com','blur-my-shell@aunetx.de','status-tray@elmopl.rs']
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

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs.gnomeExtensions) appindicator blur-my-shell status-tray;
    };

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
  };
}
