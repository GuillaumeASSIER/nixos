# Agents

This is a NixOS configuration project managed with flakes, using the [dendritic pattern](https://github.com/mightyiam/dendritic).

## Project Overview

Personal NixOS configuration for two laptops:
- **honor**: Intel-based laptop (GNOME + GDM + Wayland)
- **pro**: AMD-based laptop (GNOME + GDM + Wayland)

Features:
- **Desktop**: GNOME (honor) / GNOME (pro)
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation / Containers**: Docker + libvirt + Podman
- **Security**: AppArmor, fail2ban, firewall, auditd
- **Firmware**: Custom DSDT overlay for Honor laptop
- **Browser**: Firefox & Chromium with policies (uBlock, Bitwarden)
- **Dev tools**: neovim, git, lazygit, opencode, kubectl, terraform, etc.
- **GPU**: Intel graphics (honor) / AMD ROCm/Vulkan (pro)

## Architecture: The Dendritic Pattern

This repo follows the [**dendritic pattern**](https://github.com/mightyiam/dendritic):

- **Every Nix file** (except `flake.nix`) is a **top-level flake-parts module** — same module system class
- **Each module implements a single feature** across all configuration classes (NixOS, home-manager) it applies to
- **File paths name features**, not configuration types — modules can be freely renamed and moved
- **Automatic importing** via [`import-tree`](https://github.com/vic/import-tree) — no manual `imports` lists
- **Lower-level modules** stored as `deferredModule` under `flake.modules.nixos.*` / `flake.modules.homeManager.*`
- **No `specialArgs` pass-thru**: every module reads from the top-level `config`

### Flow

1. `flake.nix` → `flake-parts` + `import-tree ./modules`
2. Each module in `modules/` is auto-imported into the flake-parts evaluation
3. Feature modules declare `flake.modules.nixos.<name>` or `flake.modules.homeManager.<name>`
4. Host assemblies (e.g. `honor.nix`) compose features via `configurations.nixos.<host>.module` + `homeManager`
5. `infra.nix` builds `nixosConfigurations` from `configurations.nixos` using `deferredModule`

### Key conventions

- New features = new files in `modules/`, auto-imported — no `flake.nix` changes needed
- To add a NixOS feature: `flake.modules.nixos.<name> = { ... };`
- To add a home-manager feature: `flake.modules.homeManager.<name> = { ... };`
- To add a host: create `modules/<host>.nix` with `configurations.nixos.<host> = { ... }`
- Module paths are feature names: rename/move freely, `import-tree` finds them

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
    ├── core.nix           # rtkit, ssh, netbird, zsh
    ├── debug.nix          # htop, btop, wireshark, etc.
    ├── gnome.nix          # GNOME, GDM, PipeWire, Flatpak, fonts, extensions
    ├── ide.nix            # git, lazygit, opencode
    ├── intel.nix          # Intel GPU tools (honor only)
    ├── journald.nix       # Journald configuration
    ├── k3s.nix            # K3s server

    ├── office.nix         # LibreOffice, Thunderbird, etc.
    ├── secureboot.nix     # Lanzaboote + Secure Boot
    ├── security.nix       # AppArmor, fail2ban, firewall
    │
    ├── # ── Home-Manager feature modules (flake.modules.homeManager.*) ──
    ├── codium.nix         # VSCodium config (HM)
    ├── shell.nix          # tmux + zsh + zoxide (HM)
    ├── ssh.nix            # SSH client config (HM)
    │
    ├── # ── Host assemblies (configurations.nixos.<host>) ──
    ├── honor.nix          # Host honor — composes NixOS + HM modules
    ├── pro.nix            # Host pro — composes NixOS + HM modules
    ├── honor-disko.nix    # Disko inline (mirrors disko/honor.nix)
    ├── honor-hardware.nix # Hardware config honor (DSDT, kernel modules)
    ├── pro-disko.nix      # Disko inline (mirrors disko/pro.nix)
    └── pro-hardware.nix   # Hardware config pro (AMD ROCm)
```

## Common Commands

```bash
# Rebuild system (requires --impure for env vars)
sudo -E nixos-rebuild switch --impure --flake .#honor

# Update dependencies
nix flake update

# Build system (without switching)
sudo -E nixos-rebuild --impure --flake .#honor

# Run all flake checks
nix flake check --impure

# Format nix files
nix fmt

# Run format + lint + dead code checks locally
nix shell nixpkgs#alejandra nixpkgs#statix nixpkgs#deadnix -c sh -c 'alejandra --check . && statix check && deadnix . '
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

## Known Issues & Tech Debt

See `ROADMAP.md` for migration history. Current outstanding items below.
