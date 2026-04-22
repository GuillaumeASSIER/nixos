# Agents

This is a NixOS configuration project managed with flakes.

## Project Overview

Personal NixOS configuration for two laptops:
- **honor**: Intel-based laptop (GNOME + GDM + Wayland)
- **pro**: AMD-based laptop (KDE Plasma)

Features:
- **Desktop**: GNOME (honor) / KDE Plasma (pro)
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation / Containers**: Docker + libvirt + Podman
- **Security**: AppArmor, fail2ban, firewall, auditd
- **Firmware**: Custom DSDT overlay for Honor laptop
- **Browser**: Firefox & Chromium with policies (uBlock, Bitwarden)
- **Dev tools**: neovim, git, lazygit, opencode, kubectl, terraform, etc.
- **GPU**: Intel graphics (honor) / AMD ROCm/Vulkan (pro)

## Structure

```
.
├── flake.nix              # Main flake entry (inputs, outputs, formatter)
├── flake.lock             # Dependency lock file
├── inventaire/
│   ├── hosts/             # Machine configurations
│   │   ├── honor/         # Honor laptop configuration
│   │   │   ├── default.nix    # Entry point for honor machine
│   │   │   ├── configuration.nix  # Main system config
│   │   │   └── hardware.nix   # Hardware & DSDT overlay config
│   │   └── pro/            # Pro machine configuration
│   │       ├── default.nix    # Entry point for pro machine
│   │       ├── configuration.nix  # Main system config
│   │       └── hardware.nix   # Hardware config
│   └── users/             # User configurations
│       ├── heap/          # heap user home config
│       │   └── home.nix   # User-level packages & programs
│       └── guillaume/     # guillaume user home config
│           └── home.nix   # User-level packages & programs
└── modules/
    ├── fixes/              # Patches for upstream nixpkgs bugs
    │   ├── pam-apparmor-include-substack.nix  # Disables stock pam.nix, imports patched copy
    │   └── pam.nix         # Patched pam.nix (filters include/substack from AppArmor check)
    ├── home/              # Home-manager base configuration (deprecated)
    │   └── home.nix       # Moved to inventaire/users/
    └── features/          # Feature modules
        ├── browser.nix    # Firefox & Chromium policies
        ├── core.nix       # Security (apparmor, fail2ban, firewall, ssh)
        ├── desktop.nix    # GNOME, GDM, PipeWire, Flatpak

        ├── ide.nix        # Git, lazygit, opencode
        ├── journald.nix   # Journald configuration
        ├── office.nix     # Office packages
        ├── plasma.nix     # KDE Plasma desktop
        ├── secureboot.nix # Secure boot configuration
        └── server.nix     # Core dumps, audit logging
```

## Common Commands

```bash
# Rebuild system (requires --impure for env vars)
sudo -E nixos-rebuild switch --impure --flake .#honor

# Update dependencies
nix flake update

# Build system (without switching)
sudo -E nixos-rebuild  --impure --flake .#honor

# Format nix files
nix fmt
```

## Environment Variables

The configuration reads secrets/values from environment variables (via `direnv`/`.envrc`). Copy `.envrc.example` to `.envrc` and fill in values:

- `OPENWEBUI_API_KEY`: API key for OpenWebUI
- `OPENWEBUI_API_URL`: OpenWebUI API URL
- `HEAP_EMAIL`: Email for heap user
- `GUILLAUME_EMAIL`: Email for guillaume user
- `VATES_GIT_HOST`: Git server hostname

## MCP Integration

This project includes MCP-NixOS integration (`.mcp.json`) for AI assistants. It provides access to:
- NixOS packages and options search
- Home Manager options
- FlakeHub registry
- Noogle (Nix function documentation)
- Package version history via NixHub

## Notes

- Users: `heap` (honor - Intel), `guillaume` (pro - AMD)
- Hostnames: `honor` (Intel graphics), `pro` (AMD ROCm/Vulkan)
- Uses `nixos-unstable` channel
- Unfree packages enabled
- Uses `disko` for disk partitioning
- Dev shell includes: alejandra, statix, deadnix
