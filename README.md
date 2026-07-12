# NixOS Configuration

Personal NixOS configuration for two laptops:

- **honor**: Intel-based laptop (GNOME + GDM + Wayland)
- **pro**: AMD-based laptop (GNOME + GDM + Wayland)

Features:
- **Desktop**: GNOME (honor) / GNOME (pro)
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation**: Docker + libvirt + Podman
- **Security**: AppArmor, fail2ban, firewall, auditd
- **Firmware**: Custom DSDT overlay (honor), linux-firmware
- **Browser**: Firefox & Chromium with policies (uBlock, Bitwarden)
- **GPU**: Intel graphics (honor) / AMD ROCm/Vulkan (pro)

Based on [Dammyr nixos-laptops-config](https://github.com/DamyrFr/nixos-laptops-config/tree/main)

## Architecture: The Dendritic Pattern

This repo follows the [**dendritic pattern**](https://github.com/mightyiam/dendritic) — a Nixpkgs module system usage pattern where:

- **Every Nix file** (except entry points like `flake.nix`) is a **top-level flake-parts module**
- **Each module implements a single feature** across all configuration classes it applies to (NixOS, home-manager, etc.)
- **File paths name features**, not configuration types — modules can be freely renamed and moved
- **Automatic importing** via [`import-tree`](https://github.com/vic/import-tree) — no manual `imports` lists to maintain
- **Lower-level modules** (NixOS, home-manager) are stored as `deferredModule` option values under `flake.modules.*`, enabling cross-cutting feature composition without `specialArgs` pass-thru

### How it works

1. `flake.nix` is a minimal entry point that delegates to `flake-parts` + `import-tree`
2. `import-tree ./modules` auto-imports every `.nix` file in `modules/` into the flake-parts evaluation
3. Each module declares its feature via `flake.modules.nixos.<name>` or `flake.modules.homeManager.<name>`
4. Host assemblies (e.g. `honor.nix`) compose features using `configurations.nixos.<host>.module` and `homeManager`
5. `infra.nix` evaluates everything by assembling `nixosConfigurations` from the top-level `configurations.nixos` options

### Benefits

- **No `specialArgs` pass-thru**: every module reads from the top-level `config`
- **File type is known**: every non-entry-point file is a Nixpkgs module system module
- **Path independence**: file paths represent features, not technical categories
- **Composability**: features span NixOS + home-manager in a single file when needed

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
└── modules/               # Auto-imported by import-tree — each file is a flake-parts module
    ├── meta.nix           # Top-level options (emails, API keys, vars)
    ├── infra.nix          # configurations.nixos, nixosConfigurations, HM, devshell
    │
    ├── # ── NixOS feature modules (flake.modules.nixos.*) ──
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
    ├── secureboot.nix     # Lanzaboote + Secure Boot
    ├── security.nix       # AppArmor, fail2ban, firewall
    │
    ├── # ── Home-Manager feature modules (flake.modules.homeManager.*) ──
    ├── codium.nix         # VSCodium config (HM)
    ├── shell.nix          # tmux + zsh + zoxide (HM)
    ├── ssh.nix            # SSH config (HM)
    │
    ├── # ── Host assemblies (configurations.nixos.<host>) ──
    ├── honor.nix          # Host honor — composes NixOS + HM modules
    ├── pro.nix            # Host pro — composes NixOS + HM modules
    ├── honor-disko.nix    # Disko inline (mirrors disko/honor.nix)
    ├── honor-hardware.nix # Hardware config honor
    ├── pro-disko.nix      # Disko inline (mirrors disko/pro.nix)
    └── pro-hardware.nix  # Hardware config pro
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