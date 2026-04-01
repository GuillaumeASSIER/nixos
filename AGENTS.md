# Agents

This is a NixOS configuration project managed with flakes.

## Project Overview

Personal NixOS configuration for a laptop (hostname: `honor`), featuring:
- **Desktop**: GNOME + GDM + Wayland
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation**: Docker + libvirt
- **Security**: Fingerprint reader (fprintd), firewalld
- **Firmware**: Custom DSDT overlay for Honor laptop

## Structure

```
.
├── flake.nix              # Main flake entry
├── flake.lock             # Dependency lock file
├── modules/
│   ├── honor/             # Machine-specific configuration
│   │   ├── default.nix
│   │   ├── configuration.nix
│   │   └── hardware.nix
│   ├── home/               # Home-manager user configuration
│   │   └── home.nix
│   └── features/           # Feature modules
│       ├── browser.nix
│       ├── core.nix
│       ├── desktop.nix
│       ├── ide.nix
│       └── server.nix
```

## Common Commands

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#honor

# Update dependencies
nix flake update

# Build system (without switching)
sudo nixos-rebuild build --flake .#honor
```

## Notes

- Username: `heap`
- Hostname: `honor`
- Uses `nixos-unstable` channel
- Unfree packages enabled
- Uses `disko` for disk partitioning
