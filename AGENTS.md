# Agents

This is a NixOS configuration project managed with flakes.

## Project Overview

Personal NixOS configuration for a laptop (hostname: `honor`), featuring:
- **Desktop**: GNOME + GDM + Wayland
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation / Containers**: Docker + libvirt + Podman
- **Security**: AppArmor, fail2ban, firewall, auditd
- **Firmware**: Custom DSDT overlay for Honor laptop
- **Browser**: Firefox & Chromium with policies (uBlock, Bitwarden)
- **Dev tools**: neovim, git, lazygit, opencode, kubectl, terraform, etc.

## Structure

```
.
├── flake.nix              # Main flake entry (inputs, outputs, formatter)
├── flake.lock             # Dependency lock file
├── modules/
│   ├── honor/             # Machine-specific configuration
│   │   ├── default.nix    # Entry point for honor machine
│   │   ├── configuration.nix  # Main system config
│   │   └── hardware.nix   # Hardware & DSDT overlay config
│   ├── home/              # Home-manager user configuration
│   │   └── home.nix       # User-level packages & programs
│   └── features/          # Feature modules
│       ├── browser.nix    # Firefox & Chromium policies
│       ├── core.nix       # Security (apparmor, fail2ban, firewall, ssh)
│       ├── desktop.nix    # GNOME, GDM, PipeWire, Flatpak
│       ├── ide.nix        # Git, lazygit, opencode
│       └── server.nix     # Core dumps, audit logging
```

## Common Commands

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#honor

# Update dependencies
nix flake update

# Build system (without switching)
sudo nixos-rebuild build --flake .#honor

# Format nix files
nix fmt
```

## MCP Integration

This project includes MCP-NixOS integration (`.mcp.json`) for AI assistants. It provides access to:
- NixOS packages and options search
- Home Manager options
- FlakeHub registry
- Noogle (Nix function documentation)
- Package version history via NixHub

## Notes

- Username: `heap`
- Hostname: `honor`
- Uses `nixos-unstable` channel
- Unfree packages enabled
- Uses `disko` for disk partitioning (currently commented out, uses ext4)
- Dev shell includes: alejandra, statix, deadnix
