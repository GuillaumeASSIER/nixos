_: {
  flake.modules.nixos.hyprland-session = {
    pkgs,
    lib,
    ...
  }: {
    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      alacritty
      kitty
      quickshell
      hyprland
      hypridle
      hyprlock
      hyprsunset
      grim
      slurp
      wl-clipboard
      mako
      polkit_gnome
      pavucontrol
      rofi
      playerctl
      brightnessctl
      wireplumber
      networkmanagerapplet
      blueman
      bluez
      kanshi
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      config.common.default = "*";
    };

    services = {
      displayManager.sessionPackages = [pkgs.hyprland];

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      pulseaudio.enable = false;

      hypridle.enable = true;

      xserver.xkb = {
        layout = lib.mkDefault "fr,us";
        options = lib.mkDefault "grp:win_space_toggle,compose:caps";
      };
    };

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11,*";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
    };
  };

  flake.modules.homeManager.hyprland-session = {pkgs, ...}: {
    home.packages = with pkgs; [
      alacritty
      kitty
      quickshell
      mako
      rofi
      playerctl
    ];

    programs.kitty.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      settings = {
        monitor = {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        };

        env = [
          {_args = ["XCURSOR_SIZE" "24"];}
          {_args = ["HYPRCURSOR_SIZE" "24"];}
        ];

        exec_cmd = [
          "quickshell"
          "mako"
          "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
        ];

        window_rule = [
          {
            match = {class = ".*";};
            name = "suppressevent maximize";
          }
          {
            match = {
              class = "xwayland:1";
              floating = true;
              fullscreen = false;
            };
            name = "nofocus";
          }
          {
            match = {class = "pavucontrol";};
            name = "float";
          }
          {
            match = {class = "pavucontrol";};
            name = "size 800 600";
          }
          {
            match = {class = "pavucontrol";};
            name = "center";
          }
          {
            match = {class = "blueman-manager";};
            name = "float";
          }
          {
            match = {class = "blueman-manager";};
            name = "size 900 600";
          }
          {
            match = {class = "blueman-manager";};
            name = "center";
          }
          {
            match = {class = "nm-connection-editor";};
            name = "float";
          }
          {
            match = {class = "nm-connection-editor";};
            name = "size 800 600";
          }
          {
            match = {class = "nm-connection-editor";};
            name = "center";
          }
          {
            match = {class = "Steam";};
            name = "workspace special silent";
          }
          {
            match = {class = "firefox";};
            name = "workspace 2 silent";
          }
          {
            match = {class = "(pavucontrol|blueman-manager|nm-connection-editor)";};
            name = "opacity 0.97 0.95";
          }
        ];
      };

      extraConfig = ''
        -- Look and feel
        hl.set("general.gaps_in", 4)
        hl.set("general.gaps_out", 8)
        hl.set("general.border_size", 2)
        hl.set("general.col.active_border", "rgba(51, 204, 255, ee) rgba(0, 255, 153, ee) 45deg")
        hl.set("general.col.inactive_border", "rgba(89, 89, 89, aa)")
        hl.set("general.resize_on_border", false)
        hl.set("general.allow_tearing", false)
        hl.set("general.layout", "dwindle")

        hl.set("decoration.rounding", 0)
        hl.set("decoration.rounding_power", 2)
        hl.set("decoration.dim_inactive", false)
        hl.set("decoration.active_opacity", 1.0)
        hl.set("decoration.inactive_opacity", 1.0)
        hl.set("decoration.shadow.enabled", true)
        hl.set("decoration.shadow.range", 4)
        hl.set("decoration.shadow.render_power", 3)
        hl.set("decoration.shadow.color", "rgba(1a, 1a, 1a, ee)")
        hl.set("decoration.blur.enabled", true)
        hl.set("decoration.blur.size", 3)
        hl.set("decoration.blur.passes", 1)
        hl.set("decoration.blur.vibrancy", 0.1696)
        hl.set("decoration.blur.new_optimizations", true)

        hl.set("animations.enabled", true)
        hl.bezier("easeOutQuint", 0.23, 1, 0.32, 1)
        hl.bezier("easeInOutCubic", 0.65, 0.05, 0.36, 1)
        hl.bezier("linear", 0, 0, 1, 1)
        hl.bezier("almostLinear", 0.5, 0.5, 0.75, 1)
        hl.bezier("quick", 0.15, 0, 0.1, 1)
        hl.animation("global", 1, 10, "default")
        hl.animation("border", 1, 5.39, "easeOutQuint")
        hl.animation("windows", 1, 4.79, "easeOutQuint")
        hl.animation("windowsIn", 1, 4.1, "easeOutQuint", "popin", 87)
        hl.animation("windowsOut", 1, 1.49, "linear", "popin", 87)
        hl.animation("fadeIn", 1, 1.73, "almostLinear")
        hl.animation("fadeOut", 1, 1.46, "almostLinear")
        hl.animation("fade", 1, 3.03, "quick")
        hl.animation("layers", 1, 3.81, "easeOutQuint")
        hl.animation("layersIn", 1, 4, "easeOutQuint", "fade")
        hl.animation("layersOut", 1, 1.5, "linear", "fade")
        hl.animation("fadeLayersIn", 1, 1.79, "almostLinear")
        hl.animation("fadeLayersOut", 1, 1.39, "almostLinear")
        hl.animation("workspaces", 1, 1.94, "almostLinear", "fade")
        hl.animation("workspacesIn", 1, 1.21, "almostLinear", "fade")
        hl.animation("workspacesOut", 1, 1.94, "almostLinear", "fade")
        hl.animation("zoomFactor", 1, 7, "quick")

        hl.set("misc.disable_hyprland_logo", true)
        hl.set("misc.disable_splash_rendering", true)

        -- Layouts
        hl.set("dwindle.preserve_split", true)
        hl.set("dwindle.force_split", 2)
        hl.set("master.new_status", "master")

        -- Input
        hl.set("input.kb_layout", "fr,us")
        hl.set("input.kb_variant", "")
        hl.set("input.kb_model", "")
        hl.set("input.kb_options", "grp:win_space_toggle,compose:caps")
        hl.set("input.kb_rules", "")
        hl.set("input.follow_mouse", 1)
        hl.set("input.sensitivity", 0)
        hl.set("input.touchpad.natural_scroll", true)
        hl.set("input.touchpad.clickfinger_behavior", true)
        hl.set("input.touchpad.scroll_factor", 0.4)
        hl.set("input.numlock_by_default", true)

        hl.set("gesture.workspace_swipe", true)
        hl.set("gesture.workspace_swipe_fingers", 3)

        -- Keybinds
        local mod = "SUPER"

        -- Apps
        hl.bind(mod .. ", Return", hl.dsp.exec_cmd("alacritty"))
        hl.bind(mod .. " SHIFT, Return", hl.dsp.exec_cmd("alacritty -e tmux"))
        hl.bind(mod .. ", B", hl.dsp.exec_cmd("firefox"))
        hl.bind(mod .. " SHIFT, B", hl.dsp.exec_cmd("firefox --private-window"))
        hl.bind(mod .. ", F", hl.dsp.exec_cmd("nautilus"))
        hl.bind(mod .. " SHIFT, W", hl.dsp.exec_cmd("rofi -show drun"))
        hl.bind(mod .. ", D", hl.dsp.exec_cmd("rofi -show drun"))
        hl.bind(mod .. ", Tab", hl.dsp.exec_cmd("rofi -show window"))
        hl.bind(mod .. ", Escape", hl.dsp.exec_cmd("hyprlock"))
        hl.bind(mod .. " SHIFT, Escape", hl.dsp.exec_cmd("hyprctl dispatch exit"))

        -- Focus (vim-style hjkl)
        hl.bind(mod .. ", H", hl.dsp.move("l"))
        hl.bind(mod .. ", L", hl.dsp.move("r"))
        hl.bind(mod .. ", K", hl.dsp.move("u"))
        hl.bind(mod .. ", J", hl.dsp.move("d"))

        -- Move windows
        hl.bind(mod .. " SHIFT, H", hl.dsp.move_window("l"))
        hl.bind(mod .. " SHIFT, L", hl.dsp.move_window("r"))
        hl.bind(mod .. " SHIFT, K", hl.dsp.move_window("u"))
        hl.bind(mod .. " SHIFT, J", hl.dsp.move_window("d"))

        -- Arrow keys
        hl.bind(mod .. ", left", hl.dsp.move("l"))
        hl.bind(mod .. ", right", hl.dsp.move("r"))
        hl.bind(mod .. ", up", hl.dsp.move("u"))
        hl.bind(mod .. ", down", hl.dsp.move("d"))
        hl.bind(mod .. " SHIFT, left", hl.dsp.move_window("l"))
        hl.bind(mod .. " SHIFT, right", hl.dsp.move_window("r"))
        hl.bind(mod .. " SHIFT, up", hl.dsp.move_window("u"))
        hl.bind(mod .. " SHIFT, down", hl.dsp.move_window("d"))

        -- Workspaces (1-9, 0=10)
        hl.bind(mod .. ", 1", hl.dsp.workspace(1))
        hl.bind(mod .. ", 2", hl.dsp.workspace(2))
        hl.bind(mod .. ", 3", hl.dsp.workspace(3))
        hl.bind(mod .. ", 4", hl.dsp.workspace(4))
        hl.bind(mod .. ", 5", hl.dsp.workspace(5))
        hl.bind(mod .. ", 6", hl.dsp.workspace(6))
        hl.bind(mod .. ", 7", hl.dsp.workspace(7))
        hl.bind(mod .. ", 8", hl.dsp.workspace(8))
        hl.bind(mod .. ", 9", hl.dsp.workspace(9))
        hl.bind(mod .. ", 0", hl.dsp.workspace(10))
        hl.bind(mod .. " SHIFT, 1", hl.dsp.move_window({ workspace = 1 }))
        hl.bind(mod .. " SHIFT, 2", hl.dsp.move_window({ workspace = 2 }))
        hl.bind(mod .. " SHIFT, 3", hl.dsp.move_window({ workspace = 3 }))
        hl.bind(mod .. " SHIFT, 4", hl.dsp.move_window({ workspace = 4 }))
        hl.bind(mod .. " SHIFT, 5", hl.dsp.move_window({ workspace = 5 }))
        hl.bind(mod .. " SHIFT, 6", hl.dsp.move_window({ workspace = 6 }))
        hl.bind(mod .. " SHIFT, 7", hl.dsp.move_window({ workspace = 7 }))
        hl.bind(mod .. " SHIFT, 8", hl.dsp.move_window({ workspace = 8 }))
        hl.bind(mod .. " SHIFT, 9", hl.dsp.move_window({ workspace = 9 }))
        hl.bind(mod .. " SHIFT, 0", hl.dsp.move_window({ workspace = 10 }))

        -- Window actions
        hl.bind(mod .. ", Q", hl.dsp.kill())
        hl.bind(mod .. ", V", hl.dsp.toggle("floating"))
        hl.bind(mod .. ", P", hl.dsp.pseudo())
        hl.bind(mod .. " SHIFT, F", hl.dsp.fullscreen(1))
        hl.bind(mod .. " SHIFT, Space", hl.dsp.toggle("floating"))
        hl.bind(mod .. " SHIFT, comma", hl.dsp.toggle("split"))

        -- Layout cycle
        hl.bind(mod .. " SHIFT, V", hl.dsp.cycle_next("dwindle", "master"))

        -- Resize submap
        hl.bind(mod .. ", R", hl.dsp.submap("resize"))
        hl.define_submap("resize", function()
          hl.bind(", H", hl.dsp.resize({ x = -5, y = 0 }), { repeating = true })
          hl.bind(", L", hl.dsp.resize({ x = 5, y = 0 }), { repeating = true })
          hl.bind(", K", hl.dsp.resize({ x = 0, y = -5 }), { repeating = true })
          hl.bind(", J", hl.dsp.resize({ x = 0, y = 5 }), { repeating = true })
          hl.bind(", left", hl.dsp.resize({ x = -5, y = 0 }), { repeating = true })
          hl.bind(", right", hl.dsp.resize({ x = 5, y = 0 }), { repeating = true })
          hl.bind(", up", hl.dsp.resize({ x = 0, y = -5 }), { repeating = true })
          hl.bind(", down", hl.dsp.resize({ x = 0, y = 5 }), { repeating = true })
          hl.bind(", Escape", hl.dsp.submap("reset"))
          hl.bind(", Return", hl.dsp.submap("reset"))
          hl.bind(mod .. ", R", hl.dsp.submap("reset"))
        end)

        -- Reload / exit / lock
        hl.bind(mod .. " SHIFT, C", hl.dsp.exec_cmd("hyprctl reload"))
        hl.bind(mod .. " SHIFT, E", hl.dsp.exec_cmd("hyprctl dispatch exit"))
        hl.bind(mod .. " SHIFT, X", hl.dsp.exec_cmd("hyprlock"))
        hl.bind(mod .. " SHIFT, R", hl.dsp.exec_cmd("rofi -show power"))

        -- Scratchpad
        hl.bind(mod .. ", S", hl.dsp.toggle_special("scratch"))
        hl.bind(mod .. " SHIFT, S", hl.dsp.move_window({ workspace = "special:scratch" }))

        -- Scroll workspaces
        hl.bind(mod .. ", mouse_down", hl.dsp.workspace("e+1"))
        hl.bind(mod .. ", mouse_up", hl.dsp.workspace("e-1"))

        -- Screenshots
        hl.bind(", Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
        hl.bind("SHIFT, Print", hl.dsp.exec_cmd("grim - | wl-copy"))
        hl.bind(mod .. ", Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"))

        -- Mouse move/resize
        hl.bind(mod .. ", mouse:272", hl.dsp.move_window())
        hl.bind(mod .. ", mouse:273", hl.dsp.resize())

        -- Multimedia keys (locked = available when screen locked)
        hl.bind(", XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
        hl.bind(", XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
        hl.bind(", XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
        hl.bind(", XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
        hl.bind(", XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true })
        hl.bind(", XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true })
        hl.bind(", XF86KbdBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 -d kbd_backlight set 5%+"), { locked = true })
        hl.bind(", XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 -d kbd_backlight set 5%-"), { locked = true })

        -- Media keys
        hl.bind(", XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
        hl.bind(", XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind(", XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind(", XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
      '';
    };

    xdg.configFile = {
      "hypr/hypridle.conf".text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock
            before_sleep_cmd = loginctl lock-session
            after_sleep_cmd = hyprctl dispatch dpms on
        }

        listener {
            timeout = 300
            on-timeout = brightnessctl -s set 10
            on-resume = brightnessctl -r
        }

        listener {
            timeout = 600
            on-timeout = loginctl lock-session
        }

        listener {
            timeout = 900
            on-timeout = hyprctl dispatch dpms off
            on-resume = hyprctl dispatch dpms on
        }

        listener {
            timeout = 1200
            on-timeout = systemctl suspend
        }
      '';
      "hypr/hyprlock.conf".text = ''
        general {
            hide_cursor = true
            grace = 0
            no_fade_in = false
        }

        background {
            monitor =
            path = screenshot
            blur_passes = 3
            blur_size = 8
        }

        input-field {
            monitor =
            size = 300, 50
            outline_thickness = 2
            dots_size = 0.25
            dots_spacing = 0.15
            fade_on_empty = true
            placeholder_text = <i>Password...</i>
            fail_text = <i>Wrong password.</i>
            position = 0, -20
            halign = center
            valign = center
        }
      '';
      "hypr/hyprsunset.conf".text = ''
        profile {
            time = 06:00
            temperature = 6500
            gamma = 100
        }

        profile {
            time = 18:00
            temperature = 4500
            gamma = 100
        }

        profile {
            time = 20:00
            temperature = 3500
            gamma = 100
        }
      '';
      "alacritty/alacritty.toml".text = ''
        [env]
        TERM = "xterm-256color"

        [terminal]
        osc52 = "CopyPaste"
        title = "Alacritty"

        [font]
        normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
        bold = { family = "JetBrainsMono Nerd Font", style = "Bold" }
        italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
        size = 10

        [window]
        padding.x = 14
        padding.y = 14
        decorations = "None"
        opacity = 0.95

        [scrolling]
        history = 10000

        [keyboard]
        bindings = [
        { key = "Insert", mods = "Shift",   action = "Paste" },
        { key = "Insert", mods = "Control", action = "Copy" },
        { key = "Return", mods = "Shift",   chars = "\u001B\r" }
        ]

        [cursor]
        style = { shape = "Block", blinking = "On" }
      '';
      "quickshell/shell.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import "bar"
        import "services"

        ShellRoot {
            Bar {}
            WifiPopup {}
            BluetoothPopup {}
            PowerMenuPopup {}
        }
      '';
      "quickshell/bar/Bar.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import QtQuick.Layouts
        import "Workspaces"
        import "Clock"
        import "StatusBlock"
        import "WifiPopup"
        import "BluetoothPopup"
        import "PowerMenuPopup"

        PanelWindow {
            id: root
            anchors {
                top: true
                left: true
                right: true
            }
            height: 30
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            Surface.namespace: "quickshell:bar"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusiveZone: 30

            Rectangle {
                anchors.fill: parent
                color: "rgba(20, 20, 20, 0.7)"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Workspaces {}
                    Item { Layout.fillWidth: true }
                    Clock {}
                    Item { Layout.fillWidth: true }
                    StatusBlock {}
                }
            }

            WifiPopup {}
            BluetoothPopup {}
            PowerMenuPopup {}
        }
      '';
      "quickshell/bar/Workspaces.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import QtQuick.Layouts
        import Quickshell.Hyprland

        RowLayout {
            id: root
            spacing: 6

            Repeater {
                model: 9
                delegate: Rectangle {
                    property int wsIndex: index + 1
                    property bool isActive: Hyprland.activeWorkspace && Hyprland.activeWorkspace.id === wsIndex
                    property bool isOccupied: Hyprland.workspaces.values.some(w => w.id === wsIndex)

                    width: 24
                    height: 24
                    radius: 4
                    color: isActive ? "rgba(0, 230, 180, 0.9)" : (isOccupied ? "rgba(150, 150, 150, 0.5)" : "rgba(80, 80, 80, 0.3)")

                    Text {
                        anchors.centerIn: parent
                        text: wsIndex
                        color: isActive ? "black" : "white"
                        font.pixelSize: 12
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + wsIndex)
                    }
                }
            }
        }
      '';
      "quickshell/bar/Clock.qml".text = ''
        import QtQuick
        import Quickshell

        Text {
            property string dateStr: {
                const d = new Date();
                const opts = { weekday: "short", day: "2-digit", month: "short" };
                return d.toLocaleDateString(Qt.locale(), Locale.ShortFormat);
            }
            property string timeStr: {
                const d = new Date();
                return d.toLocaleTimeString(Qt.locale(), "HH:mm");
            }

            text: dateStr + "  " + timeStr
            color: "white"
            font.pixelSize: 13
            font.family: "JetBrainsMono Nerd Font"
        }
      '';
      "quickshell/bar/StatusBlock.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import QtQuick.Layouts
        import Quickshell.Services.Pipewire
        import Quickshell.Services.UPower
        import Quickshell.Bluetooth
        import Quickshell.Networking

        RowLayout {
            id: root
            spacing: 10

            Text {
                property var sink: Pipewire.defaultAudioSink
                property real vol: sink ? sink.volume : 0
                property bool muted: sink ? sink.muted : false
                text: muted ? "MUTE" : Math.round(vol * 100) + "%"
                color: "white"
                font.pixelSize: 12
            }

            Text {
                property bool wifiEnabled: Networking.wifiEnabled
                text: wifiEnabled ? "WIFI" : "NO-WIFI"
                color: wifiEnabled ? "#00e6b4" : "#888"
                font.pixelSize: 12
            }

            Text {
                property bool btOn: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
                text: btOn ? "BT" : "BT-OFF"
                color: btOn ? "#00aaff" : "#888"
                font.pixelSize: 12
            }

            Text {
                property var display: UPower.displayDevice
                property real pct: display ? display.percentage : 0
                property bool charging: display && display.state === UPowerDeviceState.Charging
                text: (pct > 0 ? Math.round(pct * 100) + "%" : "") + (charging ? " ⚡" : "")
                color: pct < 0.2 ? "#ff5555" : "white"
                font.pixelSize: 12
            }
        }
      '';
      "quickshell/services/WifiPopup.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import QtQuick.Layouts
        import Quickshell.Networking

        PopupWindow {
            id: popup
            anchor.window: parent
            anchor.rect.x: 0
            anchor.rect.y: 30
            width: 320
            height: 400
            color: "rgba(20, 20, 20, 0.95)"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Text {
                    text: "Wi-Fi Networks"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 14
                }

                Repeater {
                    model: Networking.wifiNetworks
                    delegate: Rectangle {
                        width: parent.width
                        height: 32
                        color: index % 2 === 0 ? "rgba(60, 60, 60, 0.5)" : "rgba(40, 40, 40, 0.5)"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.ssid + " (" + Math.round(modelData.strength * 100) + "%)"
                            color: "white"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Quickshell.execCmd("nmcli device wifi connect \"" + modelData.ssid + "\"");
                                popup.visible = false;
                            }
                        }
                    }
                }
            }
        }
      '';
      "quickshell/services/BluetoothPopup.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import QtQuick.Layouts
        import Quickshell.Bluetooth

        PopupWindow {
            id: popup
            anchor.window: parent
            anchor.rect.x: 0
            anchor.rect.y: 30
            width: 300
            height: 400
            color: "rgba(20, 20, 20, 0.95)"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Text {
                    text: "Bluetooth Devices"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 14
                }

                Repeater {
                    model: Bluetooth.devices
                    delegate: Rectangle {
                        width: parent.width
                        height: 32
                        color: modelData.connected ? "rgba(0, 170, 0, 0.3)" : "rgba(60, 60, 60, 0.5)"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name + (modelData.connected ? " (connected)" : "")
                            color: "white"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.paired) {
                                    Quickshell.execCmd("bluetoothctl " + (modelData.connected ? "disconnect" : "connect") + " " + modelData.address);
                                } else {
                                    Quickshell.execCmd("bluetoothctl pair " + modelData.address + " && bluetoothctl connect " + modelData.address);
                                }
                                popup.visible = false;
                            }
                        }
                    }
                }
            }
        }
      '';
      "quickshell/services/PowerMenuPopup.qml".text = ''
        import QtQuick
        import Quickshell
        import Quickshell.Wayland
        import QtQuick.Layouts

        component PowerItem : Rectangle {
            property string label
            property string cmd
            property var popup
            width: parent.width
            height: 28
            color: mouse.containsMouse ? "rgba(100, 100, 100, 0.5)" : "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: parent.label
                color: "white"
                font.pixelSize: 12
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execCmd(parent.cmd);
                    parent.popup.visible = false;
                }
            }
        }

        PopupWindow {
            id: popup
            anchor.window: parent
            anchor.rect.x: 0
            anchor.rect.y: 30
            width: 250
            height: 200
            color: "rgba(20, 20, 20, 0.95)"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Text {
                    text: "Power Menu"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 14
                }

                PowerItem { label: "Lock";     cmd: "hyprlock";              popup: popup }
                PowerItem { label: "Logout";   cmd: "hyprctl dispatch exit"; popup: popup }
                PowerItem { label: "Suspend";  cmd: "systemctl suspend";     popup: popup }
                PowerItem { label: "Reboot";   cmd: "systemctl reboot";      popup: popup }
                PowerItem { label: "Shutdown"; cmd: "systemctl poweroff";    popup: popup }
            }
        }
      '';
    };

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell status bar";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.quickshell}/bin/quickshell";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
