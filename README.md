# NixOS Configuration

Personal NixOS configuration for my laptop (honor), featuring:

- **Desktop**: GNOME + GDM + Wayland
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation**: Docker + libvirt + Podman
- **Security**: AppArmor, fail2ban, firewall, auditd
- **Firmware**: Custom DSDT overlay for Honor laptop
- **Browser**: Firefox & Chromium with policies (uBlock, Bitwarden)

Based on [Dammyr nixos-laptops-config](https://github.com/DamyrFr/nixos-laptops-config/tree/main)

## Structure

```
.
├── flake.nix              # Main flake entry
├── modules/
│   ├── honor/             # Machine-specific (honor)
│   │   ├── configuration.nix
│   │   ├── hardware.nix
│   │   └── default.nix
│   ├── home/              # Home-manager user config
│   │   └── home.nix
│   └── features/          # Feature modules
│       ├── browser.nix    # Firefox & Chromium policies
│       ├── core.nix       # Security (apparmor, fail2ban, firewall)
│       ├── desktop.nix    # GNOME, GDM, PipeWire
│       ├── ide.nix        # Git, lazygit, opencode
│       └── server.nix     # Core dumps, audit logging
```

## Building

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#honor

# Update dependencies
nix flake update

# Format nix files
nix fmt
```
