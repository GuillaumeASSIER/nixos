{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
in {
  flake.modules.nixos.niri = {
    pkgs,
    lib,
    ...
  }: {
    programs.niri.enable = true;

    services.displayManager.gdm.enable = true;

    boot = {
      plymouth = {
        enable = true;
        theme = "bgrt";
      };
      initrd.systemd.enable = true;
    };

    security.pam.services.login.enableGnomeKeyring = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = true;

    services.dbus.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config.niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
    };

    services.upower.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      brightnessctl
      swaybg
      playerctl
      pavucontrol
      networkmanagerapplet
      blueman
      wl-clipboard
      cliphist
      fuzzel
    ];
  };

  flake.modules.homeManager.niri = {
    pkgs,
    ...
  }: let
    font = "JetBrains Mono Nerd Font 11";
    bg = "#1e1e2e";
    fg = "#cdd6f4";
    dim = "#6c7086";
    accent = "#89b4fa";
    red = "#f38ba8";
    green = "#a6e3a1";
    yellow = "#f9e2af";
  in {
    home.packages = with pkgs; [
      (nerd-fonts.jetbrains-mono or jetbrains-mono)
    ];

    programs.niri = {
      settings = {
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
        cursor = {
          theme = "Adwaita";
          size = 24;
        };
        screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d-%H%M%S.png";
        environment = {
          DISPLAY = ":0";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          CLUTER_BACKEND = "wayland";
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
          MOZ_ENABLE_WAYLAND = "1";
          MOZ_DBUS_REMOTE = "1";
          _JAVA_AWT_WM_NONREPARENTING = "1";
          GDK_BACKEND = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
        input = {
          keyboard = {
            xkb = {
              layout = "fr";
              variant = "";
            };
          };
          touchpad = {
            tap = true;
            dwt = true;
            natural-scroll = true;
          };
          mouse = {
            accel-profile = "flat";
          };
          focus-follows-mouse.enable = true;
        };
        outputs = {
          "eDP-1" = {
            scale = 1.0;
            mode = {
              width = 1920;
              height = 1200;
              refresh = 60.0;
            };
            position = {
              x = 0;
              y = 0;
            };
          };
        };
        layout = {
          focus-ring = {
            width = 2;
            active.color = accent;
            inactive.color = dim;
          };
          default-column-width = {proportion = 0.5;};
          gaps = 8;
          struts = {
            left = 4;
            right = 4;
            top = 4;
            bottom = 4;
          };
          center-focused-column = "never";
        };
        binds = {
          "Mod+Return".action.spawn = ["foot"];
          "Mod+D".action.spawn = ["fuzzel"];
          "Mod+Shift+E".action.quit = [];

          "Mod+Left".action.focus-column-left = [];
          "Mod+Right".action.focus-column-right = [];
          "Mod+Down".action.focus-window-down = [];
          "Mod+Up".action.focus-window-up = [];
          "Mod+Shift+Left".action.move-column-left = [];
          "Mod+Shift+Right".action.move-column-right = [];
          "Mod+Shift+Down".action.move-window-down = [];
          "Mod+Shift+Up".action.move-window-up = [];
          "Mod+Home".action.focus-column-first = [];
          "Mod+End".action.focus-column-last = [];

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;

          "Mod+Comma".action.consume-window-into-column = [];
          "Mod+Period".action.expel-window-from-column = [];
          "Mod+BracketLeft".action.focus-monitor-left = [];
          "Mod+BracketRight".action.focus-monitor-right = [];
          "Mod+Shift+BracketLeft".action.move-column-to-monitor-left = [];
          "Mod+Shift+BracketRight".action.move-column-to-monitor-right = [];

          "Mod+Minus".action.set-column-width = "-5%";
          "Mod+Equal".action.set-column-width = "+5%";
          "Mod+Shift+Minus".action.set-window-height = "-5%";
          "Mod+Shift+Equal".action.set-window-height = "+5%";
          "Mod+Shift+F".action.toggle-window-floating = [];
          "Mod+F".action.fullscreen-window = [];
          "Mod+W".action.toggle-column-tabbed-display = [];

          "Ctrl+Alt+L".action.spawn = ["loginctl" "lock-session"];

          "Print".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];
          "Mod+Print".action.screenshot = [];

          "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"];
          "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"];
          "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
          "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "5%+" "-q"];
          "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "5%-" "-q"];
        };
        spawn-at-startup = [
          {command = ["waybar"];}
          {command = ["mako"];}
          {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];}
          {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
          {command = ["nm-applet" "--indicator"];}
          {command = ["blueman-applet"];}
        ];
      };
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;
        modules-left = ["niri/workspaces" "niri/window"];
        modules-center = ["clock"];
        modules-right = ["tray" "pulseaudio" "network" "bluetooth" "battery" "backlight"];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "○";
            focused = "●";
          };
        };
        "niri/window" = {format = "{}";};
        tray = {
          spacing = 8;
          icon-size = 16;
        };
        clock = {
          format = " {:%H:%M} ";
          format-alt = " {:%Y-%m-%d} ";
          format-alt-click = "click-right";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "  muted";
          format-icons = {
            default = ["♪" "♪" "♪"];
            headphone = "🎧";
          };
          on-click = "pavucontrol";
        };
        network = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "  disconnected";
          on-click = "nm-connection-editor";
        };
        bluetooth = {
          format = "  {status}";
          format-connected = "  {device_alias}";
          on-click = "blueman-manager";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-icons = ["" "" "" "" ""];
        };
        backlight = {
          format = " {percent}%";
          on-scroll-up = "brightnessctl set 5%+ -q";
          on-scroll-down = "brightnessctl set 5%- -q";
        };
      };
      style = ''
        * {
            font-family: JetBrainsMono Nerd Font;
            font-size: 11px;
            min-height: 0;
        }
        window#waybar {
            background: ${bg};
            color: ${fg};
        }
        .modules-left, .modules-center, .modules-right {
            margin: 0 4px;
        }
        #workspaces button {
            padding: 0 6px;
            color: ${dim};
        }
        #workspaces button.focused {
            color: ${accent};
        }
        #tray, #pulseaudio, #network, #bluetooth, #battery, #backlight, #clock {
            padding: 0 8px;
            margin: 0 2px;
            border-radius: 4px;
        }
        #clock {
            color: ${fg};
        }
        #tray {
            color: ${fg};
        }
        #pulseaudio {
            color: ${accent};
        }
        #network {
            color: ${green};
        }
        #network.disconnected {
            color: ${red};
        }
        #bluetooth {
            color: ${accent};
        }
        #battery {
            color: ${green};
        }
        #battery.warning {
            color: ${yellow};
        }
        #battery.critical {
            color: ${red};
        }
        #backlight {
            color: ${yellow};
        }
      '';
    };

    services.mako = {
      enable = true;
      settings = {
        background-color = bg;
        border-color = accent;
        text-color = fg;
        border-radius = 8;
        border-size = 2;
        default-timeout = 5000;
        font = font;
        icons = true;
        max-icon-size = 64;
        padding = 12;
        width = 400;
      };
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = font;
          icon-theme = "Adwaita";
          show-icons = true;
          width = 40;
          lines = 12;
          horizontal-pad = 12;
          vertical-pad = 8;
          inner-pad = 8;
        };
        colors = {
          background = "${bg}dd";
          text = "${fg}ff";
          match = "${accent}ff";
          selection = "${dim}33";
          selection-text = "${fg}ff";
          selection-match = "${accent}ff";
          border = "${accent}ff";
        };
        border = {
          width = 2;
          radius = 8;
        };
      };
    };

    services.cliphist.enable = true;

    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;
  };
}