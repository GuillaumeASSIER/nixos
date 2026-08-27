{...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      printing.enable = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    services.pulseaudio.enable = false;

    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        dejavu_fonts
        jetbrains-mono
      ];
      fontconfig = {
        antialias = true;
        hinting = {
          enable = true;
          style = "slight";
        };
        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };
        defaultFonts = {
          serif = ["Noto Serif" "DejaVu Serif"];
          sansSerif = ["Noto Sans" "DejaVu Sans"];
          monospace = ["JetBrains Mono" "DejaVu Sans Mono"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };

    environment.systemPackages =
      builtins.attrValues {
        inherit (pkgs.gnomeExtensions) appindicator blur-my-shell caffeine dash-to-dock just-perfection status-tray vertical-workspaces;
      }
      ++ [
        pkgs.gnome-tweaks
      ];

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
  };

  flake.modules.homeManager.desktop = {
    pkgs,
    config,
    ...
  }: {
    home.pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
      gtk4.theme = config.gtk.theme;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    xdg = {
      enable = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        cursor-theme = "Adwaita";
        cursor-size = 24;
        gtk-theme = "Adwaita";
        icon-theme = "Adwaita";
      };

      "org/gnome/shell" = {
        favorite-apps = ["org.gnome.Nautilus.desktop" "firefox.desktop"];
      };

      "org/gnome/shell/extensions/appindicator" = {
        icon-brightness = 0.0;
        icon-contrast = 0.0;
        icon-opacity = 240;
        icon-saturation = 0.0;
        icon-size = 0;
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        settings-version = 2;
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        brightness = 0.6;
        sigma = 30;
        static-blur = true;
        style-dash-to-dock = 0;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/caffeine" = {
        cli-toggle = false;
        indicator-position-max = 1;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        background-opacity = 0.8;
        dash-max-icon-size = 48;
        dock-position = "BOTTOM";
        extend-height = false;
        height-fraction = 0.9;
        multi-monitor = false;
        preferred-monitor = -2;
        preferred-monitor-by-connector = "eDP-1";
      };

      "org/gnome/shell/extensions/just-perfection" = {
        activities-button = false;
        panel = true;
        support-notifier-showed-version = 36;
        support-notifier-type = 0;
      };

      "org/gnome/shell/extensions/vertical-workspaces" = {
        aaa-loading-profile = true;
        always-activate-selected-window = false;
        animation-speed-factor = 100;
        app-display-module = true;
        app-favorites-module = true;
        app-folder-close-button = true;
        app-folder-order = 0;
        app-folder-remove-button = 1;
        app-grid-active-preview = false;
        app-grid-animation = 4;
        app-grid-bg-blur-sigma = 100;
        app-grid-bg-brightness = 50;
        app-grid-columns = 0;
        app-grid-content = 2;
        app-grid-folder-center = false;
        app-grid-folder-columns = 0;
        app-grid-folder-icon-grid = 3;
        app-grid-folder-icon-size = -1;
        app-grid-folder-rows = 0;
        app-grid-folder-spacing = 12;
        app-grid-icon-size = -1;
        app-grid-incomplete-pages = false;
        app-grid-names = 1;
        app-grid-order = 4;
        app-grid-orientation = 0;
        app-grid-page-height-scale = 90;
        app-grid-page-width-scale = 90;
        app-grid-performance = false;
        app-grid-remember-page = false;
        app-grid-rows = 0;
        app-grid-show-package-type = 1;
        app-grid-show-page-arrows = true;
        app-grid-show-page-indicators = true;
        app-grid-spacing = 12;
        app-menu-close-wins-ws = true;
        app-menu-force-quit = true;
        app-menu-move-app = true;
        app-menu-window-tmb = true;
        center-app-grid = true;
        center-dash-to-ws = false;
        center-search = true;
        click-empty-close = false;
        close-ws-button-mode = 2;
        dash-bg-color = 1;
        dash-bg-gs3-style = false;
        dash-bg-opacity = 20;
        dash-bg-radius = 18;
        dash-icon-scroll = 2;
        dash-isolate-workspaces = false;
        dash-max-icon-size = 0;
        dash-module = true;
        dash-position = 0;
        dash-position-adjust = -100;
        dash-show-windows-before-activation = 0;
        delay-startup = false;
        enable-page-shortcuts = true;
        favorites-notify = 1;
        highlighting-style = 1;
        hot-corner-action = 2;
        hot-corner-fullscreen = true;
        hot-corner-position = 0;
        hot-corner-ripples = true;
        layout-module = true;
        message-tray-module = true;
        new-window-focus-fix = false;
        new-window-monitor-fix = false;
        notification-position = 2;
        osd-position = 6;
        osd-window-module = true;
        overlay-key-module = true;
        overlay-key-primary = 1;
        overlay-key-secondary = 1;
        overview-bg-blur-sigma = 100;
        overview-bg-brightness = 50;
        overview-esc-behavior = 0;
        overview-mode = 0;
        overview-select-window = 0;
        overview-sort-windows = 0;
        panel-module = true;
        panel-overview-style = 1;
        panel-position = 0;
        panel-visibility = 0;
        running-dot-style = 1;
        search-app-grid-mode = 1;
        search-bg-brightness = 50;
        search-controller-module = true;
        search-fuzzy = false;
        search-icon-size = 0;
        search-include-settings = true;
        search-max-results-rows = 5;
        search-module = true;
        search-results-bg-style = 0;
        search-view-animation = 0;
        search-width-scale = 100;
        search-windows-icon-scroll = 1;
        sec-wst-position-adjust = 0;
        secondary-ws-preview-scale = 95;
        secondary-ws-preview-shift = false;
        secondary-ws-thumbnail-scale = 13;
        secondary-ws-thumbnails-position = 2;
        show-app-icon-position = 0;
        show-overview-background = 1;
        show-search-entry = false;
        show-ws-preview-bg = true;
        show-ws-switcher-bg = false;
        show-wst-labels = 3;
        show-wst-labels-on-hover = false;
        startup-state = 0;
        swipe-tracker-module = true;
        win-attention-handler-module = true;
        win-preview-height-compensation = 50;
        win-preview-icon-size = 1;
        win-preview-mid-mouse-btn-action = 0;
        win-preview-sec-mouse-btn-action = 3;
        win-preview-show-close-button = true;
        win-title-position = 0;
        window-attention-mode = 0;
        window-icon-click-action = 1;
        window-manager-module = true;
        window-preview-module = true;
        workspace-animation = 1;
        workspace-animation-module = true;
        workspace-module = true;
        workspace-switcher-animation = 1;
        workspace-switcher-popup-module = true;
        ws-max-spacing = 350;
        ws-preview-bg-radius = 30;
        ws-preview-scale = 95;
        ws-sw-popup-h-position = 50;
        ws-sw-popup-mode = 1;
        ws-sw-popup-v-position = 95;
        ws-switcher-ignore-last = false;
        ws-switcher-mode = 0;
        ws-switcher-wraparound = false;
        ws-thumbnail-scale = 13;
        ws-thumbnail-scale-appgrid = 13;
        ws-thumbnails-full = false;
        ws-thumbnails-position = 1;
        wst-position-adjust = 0;
      };
    };
  };
}
