{
  ...
}: let
  hyprlandLua = ''
    -- ============================================================
    -- Hyprland configuration (Lua, 0.55+)
    -- Inspired by Omarchy + i3-style bindings
    -- ============================================================

    ----------------------
    ---- MONITORS --------
    ----------------------

    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })

    -----------------------
    ---- PROGRAMS ---------
    -----------------------

    local terminal    = "alacritty"
    local fileManager = "nautilus"
    local menu        = "rofi -show drun"
    local browser     = "firefox"
    local lockscreen  = "hyprlock"

    -----------------------
    ---- AUTOSTART -------
    -----------------------

    hl.on("hyprland.start", function ()
        os.execute("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
        os.execute("dbus-update-activation-environment --systemd --all")

        hl.exec_cmd("quickshell")
        hl.exec_cmd("mako")
        hl.exec_cmd("/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("hyprsunset")
        hl.exec_cmd("hyprpaper")
    end)

    -------------------------------
    ---- ENVIRONMENT VARIABLES ---
    -------------------------------

    hl.env("XCURSOR_SIZE", "24")
    hl.env("HYPRCURSOR_SIZE", "24")
    hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_TYPE", "wayland")
    hl.env("MOZ_ENABLE_WAYLAND", "1")
    hl.env("QT_QPA_PLATFORM", "wayland;xcb")
    hl.env("GDK_BACKEND", "wayland,x11,*")
    hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
    hl.env("OZONE_PLATFORM", "wayland")

    -----------------------
    ---- LOOK AND FEEL ----
    -----------------------

    hl.config({
        general = {
            gaps_in  = 4,
            gaps_out = 8,
            border_size = 2,

            col = {
                active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
                inactive_border = "rgba(595959aa)",
            },

            resize_on_border = false,
            allow_tearing = false,

            layout = "dwindle",
        },

        decoration = {
            rounding       = 0,
            rounding_power = 2,
            dim_inactive   = false,
            active_opacity   = 1.0,
            inactive_opacity = 1.0,

            shadow = {
                enabled      = true,
                range        = 4,
                render_power = 3,
                color        = 0xee1a1a1a,
            },

            blur = {
                enabled   = true,
                size      = 3,
                passes    = 1,
                vibrancy  = 0.1696,
                new_optimizations = true,
            },
        },

        animations = {
            enabled = true,
        },

        misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
        },
    })

    -- Default curves and animations
    hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
    hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
    hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
    hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

    hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

    hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
    hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
    hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
    hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
    hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
    hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

    -----------------------
    ---- LAYOUTS ----------
    -----------------------

    hl.config({
        dwindle = {
            preserve_split = true,
            force_split = 2,
        },
        master = {
            new_status = "master",
        },
        scrolling = {
            fullscreen_on_one_column = true,
        },
    })

    -----------------
    ---- INPUT ------
    -----------------

    hl.config({
        input = {
            kb_layout  = "fr,us",
            kb_variant = "",
            kb_model   = "",
            kb_options = "grp:win_space_toggle,compose:caps",
            kb_rules   = "",

            follow_mouse = 1,
            sensitivity = 0,

            touchpad = {
                natural_scroll = true,
                clickfinger_behavior = true,
                scroll_factor = 0.4,
            },

            numlock_by_default = true,
        },
    })

    hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace"
    })

    ----------------------
    ---- KEYBINDINGS -----
    ----------------------

    local mod = "SUPER"

    -- Apps
    hl.bind(mod .. " + RETURN",     hl.dsp.exec_cmd(terminal))
    hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal .. " -e tmux"))
    hl.bind(mod .. " + B",          hl.dsp.exec_cmd(browser))
    hl.bind(mod .. " + SHIFT + B",  hl.dsp.exec_cmd("firefox --private-window"))
    hl.bind(mod .. " + F",          hl.dsp.exec_cmd(fileManager))
    hl.bind(mod .. " + SHIFT + W",  hl.dsp.exec_cmd(menu))
    hl.bind(mod .. " + D",          hl.dsp.exec_cmd(menu))
    hl.bind(mod .. " + TAB",        hl.dsp.exec_cmd("rofi -show window"))
    hl.bind(mod .. " + ESCAPE",     hl.dsp.exec_cmd(lockscreen))
    hl.bind(mod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd("hyprctl dispatch exit"))

    -- Focus (vim-style hjkl)
    hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

    -- Move
    hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

    -- Arrow key focus / move (i3-style)
    hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))
    hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
    hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
    hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

    -- Workspaces (1..9 + 0 = 10)
    for i = 1, 10 do
        local key = i % 10
        hl.bind(mod .. " + " .. key,            hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key,    hl.dsp.window.move({ workspace = i }))
    end

    -- Window actions
    hl.bind(mod .. " + Q",          hl.dsp.window.close())
    hl.bind(mod .. " + V",          hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mod .. " + P",          hl.dsp.window.pseudo())
    hl.bind(mod .. " + SHIFT + F",  hl.dsp.exec_cmd("hyprctl dispatch fullscreen 1"))
    hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("hyprctl dispatch togglefloating"))
    hl.bind(mod .. " + SHIFT + J",  hl.dsp.layout("togglesplit"))

    -- Layout cycle
    hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("hyprctl dispatch cyclenext dwindle master"))

    -- Resize
    hl.bind(mod .. " + R", hl.dsp.exec_map("hyprctl dispatch submap resize"))
    hl.submap("resize")
        hl.bind("", "H",            hl.dsp.resize({ width  = "-20", height = "0"   }))
        hl.bind("", "L",            hl.dsp.resize({ width  = "20",  height = "0"   }))
        hl.bind("", "K",            hl.dsp.resize({ width  = "0",   height = "-20" }))
        hl.bind("", "J",            hl.dsp.resize({ width  = "0",   height = "20"  }))
        hl.bind("", "left",         hl.dsp.resize({ width  = "-20", height = "0"   }))
        hl.bind("", "right",        hl.dsp.resize({ width  = "20",  height = "0"   }))
        hl.bind("", "up",           hl.dsp.resize({ width  = "0",   height = "-20" }))
        hl.bind("", "down",         hl.dsp.resize({ width  = "0",   height = "20"  }))
        hl.bind("", "Escape",       hl.dsp.submap("reset"))
        hl.bind("", "RETURN",       hl.dsp.submap("reset"))
        hl.bind(mod .. " + R",       hl.dsp.submap("reset"))
    hl.submap("reset")

    -- Reload / exit
    hl.bind(mod .. " + SHIFT + C",  hl.dsp.exec_cmd("hyprctl reload"))
    hl.bind(mod .. " + SHIFT + E",  hl.dsp.exec_cmd("hyprctl dispatch exit"))
    hl.bind(mod .. " + SHIFT + X",  hl.dsp.exec_cmd("hyprlock"))
    hl.bind(mod .. " + SHIFT + R",  hl.dsp.exec_cmd("rofi -show power"))

    -- Special workspace (scratchpad)
    hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("scratch"))
    hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratch" }))

    -- Scroll through existing workspaces
    hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

    -- Screenshots
    hl.bind("",         "Print",  hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
    hl.bind("SHIFT",    "Print",  hl.dsp.exec_cmd("grim - | wl-copy"))
    hl.bind(mod .. " + Print",    hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"))

    -- Move / resize with mouse
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Laptop multimedia keys
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),     { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),          { locked = true, repeating = true })
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),         { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),       { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                      { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                      { locked = true, repeating = true })
    hl.bind("XF86KbdBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 -d kbd_backlight set 5%+"),     { locked = true, repeating = true })
    hl.bind("XF86KbdBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 -d kbd_backlight set 5%-"),     { locked = true, repeating = true })

    -- Media
    hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

    --------------------------------
    ---- WINDOWS AND WORKSPACES ----
    --------------------------------

    hl.window_rule({
        name  = "suppress-maximize-events",
        match = { class = ".*" },
        suppress_event = "maximize",
    })

    hl.window_rule({
        name  = "fix-xwayland-drags",
        match = {
            class      = "^$",
            title      = "^$",
            xwayland   = true,
            float      = true,
            fullscreen = false,
            pin        = false,
        },
        no_focus = true,
    })

    hl.window_rule({
        match = { class = "pavucontrol" },
        float = true,
        size = "800 600",
        center = true,
    })

    hl.window_rule({
        match = { class = "blueman-manager" },
        float = true,
        size = "900 600",
        center = true,
    })

    hl.window_rule({
        match = { class = "nm-connection-editor" },
        float = true,
        size = "800 600",
        center = true,
    })

    hl.window_rule({
        match = { class = "Steam" },
        workspace = "special silent",
    })

    hl.window_rule({
        match = { class = "firefox" },
        workspace = "2 silent",
    })

    hl.window_rule({
        match = { class = "pavucontrol|blueman-manager|nm-connection-editor" },
        opacity = "0.97 0.95",
    })
  '';

  hypridleConfig = ''
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

  hyprlockConfig = ''
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

  hyprsunsetConfig = ''
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

  alacrittyConfig = ''
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

  quickshellShell = ''
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

  quickshellBar = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland
    import QtQuick.Layouts
    import Quickshell.Services.Pipewire
    import Quickshell.Services.UPower
    import Quickshell.Services.Notifications
    import "Workspaces"
    import "Clock"
    import "StatusBlock"

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
    }
  '';

  quickshellWorkspaces = ''
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

  quickshellClock = ''
    import QtQuick
    import Quickshell
    import QtQuick.Layouts
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

  quickshellStatus = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland
    import QtQuick.Layouts
    import Quickshell.Services.Pipewire
    import Quickshell.Services.UPower
    import Quickshell.Bluetooth

    RowLayout {
        id: root
        spacing: 10

        // Volume
        Text {
            property var sink: Pipewire.defaultAudioSink
            property real vol: sink ? sink.volume : 0
            property bool muted: sink ? sink.muted : false
            text: muted ? "MUTE" : Math.round(vol * 100) + "%"
            color: "white"
            font.pixelSize: 12
        }

        // Wi-Fi
        Text {
            property bool wifiEnabled: Networking.wifiEnabled
            text: wifiEnabled ? "WIFI" : "NO-WIFI"
            color: wifiEnabled ? "#00e6b4" : "#888"
            font.pixelSize: 12
        }

        // Bluetooth
        Text {
            property bool btOn: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
            text: btOn ? "BT" : "BT-OFF"
            color: btOn ? "#00aaff" : "#888"
            font.pixelSize: 12
        }

        // Battery
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

  quickshellWifiPopup = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland
    import QtQuick.Layouts
    import Quickshell.Networking

    PopupWindow {
        id: root
        anchor.window: bar
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
                            root.visible = false;
                        }
                    }
                }
            }
        }
    }
  '';

  quickshellBluetoothPopup = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland
    import QtQuick.Layouts
    import Quickshell.Bluetooth

    PopupWindow {
        id: root
        anchor.window: bar
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
                            root.visible = false;
                        }
                    }
                }
            }
        }
    }
  '';

  quickshellPowerMenu = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland
    import QtQuick.Layouts

    PopupWindow {
        id: root
        anchor.window: bar
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

            PowerItem { label: "Lock";    cmd: "hyprlock" }
            PowerItem { label: "Logout";  cmd: "hyprctl dispatch exit" }
            PowerItem { label: "Suspend"; cmd: "systemctl suspend" }
            PowerItem { label: "Reboot";  cmd: "systemctl reboot" }
            PowerItem { label: "Shutdown"; cmd: "systemctl poweroff" }
        }

        component PowerItem : Rectangle {
            property string label
            property string cmd
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
                    root.visible = false;
                }
            }
        }
    }
  '';
in {
  flake.modules.nixos.hyprland-session = {
    pkgs,
    lib,
    ...
  }: let
    autoKeymap = pkgs.writeShellScriptBin "auto-keymap" ''
      #!/usr/bin/env bash
      # Switch Hyprland xkb layout when a USB keyboard is plugged in.
      # Default: keyboard internal = fr (AZERTY), USB = us (QWERTY).
      set -euo pipefail

      DEV="''${1:-}"
      logger -t auto-keymap "device added: ''${DEV}"

      # Wait for Hyprland socket (max 10s)
      for _ in $(seq 1 20); do
        if [[ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] \
          || ls /tmp/hypr/*/.socket.sock >/dev/null 2>&1; then
          break
        fi
        sleep 0.5
      done

      # If the device is a USB keyboard (HID), apply the us layout
      if [[ -e /sys/class/input/"$DEV"/device ]]; then
        DEV_PATH=$(readlink -f /sys/class/input/"$DEV"/device || true)
        if [[ "$DEV_PATH" == *usb* ]]; then
          logger -t auto-keymap "USB keyboard detected ($DEV_PATH) -> switching to us"
          hyprctl switchxkblayout all us 2>/dev/null || true
          exit 0
        fi
      fi

      # Otherwise, switch back to fr
      logger -t auto-keymap "non-USB keyboard -> switching to fr"
      hyprctl switchxkblayout all fr 2>/dev/null || true
    '';

    udevKeyboardRule = pkgs.writeText "90-keyboard-layout.rules" ''
      ACTION=="add", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", \
        ENV{DEVNAME}!="", \
        RUN+="${autoKeymap}/bin/auto-keymap %k"
    '';
  in {
    environment.systemPackages = with pkgs; [
      alacritty
      quickshell
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
      autoKeymap
    ];

    environment.etc."udev/rules.d/90-keyboard-layout.rules".source = udevKeyboardRule;

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    services.pulseaudio.enable = false;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.hypridle.enable = true;

    services.xserver.xkb = {
      layout = lib.mkDefault "fr,us";
      options = lib.mkDefault "grp:win_space_toggle,compose:caps";
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
      quickshell
      mako
      rofi
      playerctl
    ];

    xdg.configFile = {
      "hypr/hyprland.lua".text = hyprlandLua;
      "hypr/hypridle.conf".text = hypridleConfig;
      "hypr/hyprlock.conf".text = hyprlockConfig;
      "hypr/hyprsunset.conf".text = hyprsunsetConfig;
      "alacritty/alacritty.toml".text = alacrittyConfig;
      "quickshell/shell.qml".text = quickshellShell;
      "quickshell/bar/Bar.qml".text = quickshellBar;
      "quickshell/bar/Workspaces.qml".text = quickshellWorkspaces;
      "quickshell/bar/Clock.qml".text = quickshellClock;
      "quickshell/bar/StatusBlock.qml".text = quickshellStatus;
      "quickshell/services/WifiPopup.qml".text = quickshellWifiPopup;
      "quickshell/services/BluetoothPopup.qml".text = quickshellBluetoothPopup;
      "quickshell/services/PowerMenuPopup.qml".text = quickshellPowerMenu;
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
