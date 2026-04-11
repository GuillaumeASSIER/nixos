# NixOS Configuration

Personal NixOS configuration for two laptops:

- **honor**: Intel-based laptop (GNOME + GDM + Wayland)
- **pro**: AMD-based laptop (KDE Plasma)

Features:
- **Desktop**: GNOME (honor) / KDE Plasma (pro)
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation**: Docker + libvirt + Podman
- **Security**: AppArmor, fail2ban, firewall, auditd
- **Firmware**: Custom DSDT overlay (honor), linux-firmware
- **Browser**: Firefox & Chromium with policies (uBlock, Bitwarden)
- **GPU**: Intel graphics (honor) / AMD ROCm/Vulkan (pro)

Based on [Dammyr nixos-laptops-config](https://github.com/DamyrFr/nixos-laptops-config/tree/main)

## Structure

```
.
├── flake.nix              # Main flake entry
├── inventaire/
│   ├── hosts/             # Machine configurations
│   │   ├── honor/         # Honor laptop (Intel)
│   │   │   ├── default.nix
│   │   │   ├── configuration.nix
│   │   │   ├── hardware.nix
│   │   │   └── disko.nix
│   │   └── pro/           # Pro laptop (AMD)
│   │       ├── default.nix
│   │       ├── configuration.nix
│   │       ├── hardware.nix
│   │       └── disko.nix
│   └── users/             # User configurations
│       ├── heap/          # heap user (honor)
│       └── guillaume/     # guillaume user (pro)
└── modules/
    ├── home/              # Home-manager base (deprecated)
    └── features/          # Feature modules
        ├── browser.nix    # Firefox & Chromium policies
        ├── core.nix       # Security
        ├── desktop.nix    # GNOME, GDM, PipeWire
        ├── ide.nix        # Git, lazygit, opencode
        ├── office.nix     # Office packages
        ├── plasma.nix     # KDE Plasma
        └── server.nix     # Core dumps, audit logging
```

## Building

```bash
# Rebuild system (honor)
sudo nixos-rebuild switch --flake .#honor

# Rebuild system (pro)
sudo nixos-rebuild switch --flake .#pro

# Update dependencies
nix flake update

# Format nix files
nix fmt
```

## Setup 

```bash
# Retrieve repository
nix-shell -p git vscodium
git clone git@github.com:GuillaumeASSIER/nixos.git
cd nixos/

# Format the disk (honor)
sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#honor --disk /dev/nvme01 inventaire/hosts/honor/disko.nix

# Format the disk (pro)
sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#pro --disk /dev/nvme01 inventaire/hosts/pro/disko.nix
```