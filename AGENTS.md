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

Uses the dendritic pattern: `flake-parts` + `import-tree` auto-imports all Nix modules from `modules/`. Each module is a top-level flake-parts module declaring its own features via `flake.modules.nixos.*` or `flake.modules.homeManager.*`. Host assemblies compose features using `configurations.nixos.<host>`.

```
.
├── flake.nix              # Minimal entry point (flake-parts + import-tree)
├── flake.lock             # Dependency lock file
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
    ├── honor-disko.nix    # Partitionnement honor
    ├── honor-hardware.nix # Hardware config honor
    ├── pro-disko.nix      # Partitionnement pro
    ├── pro-hardware.nix   # Hardware config pro
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
