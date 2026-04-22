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
├── flake.nix              # Minimal entry point (flake-parts + import-tree)
├── flake.lock             # Dependency lock file
├── disko/
│   ├── honor.nix          # Disko partition config for honor (standalone, CLI usage)
│   └── pro.nix            # Disko partition config for pro (standalone, CLI usage)
├── patches/
│   └── pam.nix            # Patched upstream pam.nix (2656 lines)
└── modules/
    ├── meta.nix           # Top-level options (emails, API keys, vars)
    ├── infra.nix          # configurations.nixos, nixosConfigurations, HM, devshell
    │
    ├── # ── NixOS feature modules ──
    ├── browser.nix        # Firefox & Chromium policies
    ├── core.nix           # rtkit, ssh, netbird, zsh, firewall
    ├── debug.nix          # htop, btop, wireshark, etc.
    ├── desktop.nix        # GNOME, GDM, PipeWire, Flatpak
    ├── ide.nix            # git, lazygit, opencode
    ├── intel.nix          # Intel GPU tools
    ├── journald.nix       # Journald configuration
    ├── k3s.nix            # K3s server
    ├── office.nix         # LibreOffice, Thunderbird, etc.
    ├── pam-fix.nix        # Fix PAM/AppArmor (disables stock pam.nix)
    ├── plasma.nix         # KDE Plasma + SDDM
    ├── secureboot.nix     # Lanzaboote + Secure Boot
    ├── security.nix       # AppArmor, fail2ban, firewall
    │
    ├── # ── Home-Manager feature modules ──
    ├── codium.nix         # VSCodium config (HM)
    ├── shell.nix          # tmux + zsh + zoxide (HM)
    ├── ssh.nix            # SSH config (HM)
    │
    ├── # ── Host assemblies ──
    ├── honor.nix          # Host honor + config specifique
    ├── pro.nix            # Host pro + config specifique
    ├── honor-disko.nix    # Disko inline (mirrors disko/honor.nix)
    ├── honor-hardware.nix # Hardware config honor
    ├── pro-disko.nix      # Disko inline (mirrors disko/pro.nix)
    └── pro-hardware.nix   # Hardware config pro
```

## Building

```bash
# Rebuild system (requires --impure for env vars)
sudo -E nixos-rebuild switch --impure --flake .#honor

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

# Format the disk (e.g. for pro)
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- --mode destroy,format,mount disko/pro.nix

# Verify mounts
mount | grep /mnt

# Install the system
sudo nixos-install --flake .#pro
```

> **Note:** The `disko/` directory contains standalone disko config files usable directly with the `disko` CLI. The `modules/*-disko.nix` files contain the same configs inline for the NixOS module system. If you modify partitioning, update both.