# NixOS Configuration

Personal NixOS configuration for my laptop (honor), featuring:

- **Desktop**: GNOME + GDM + Wayland
- **Audio**: PipeWire with PulseAudio passthrough
- **Virtualisation**: Docker + libvirt
- **Security**: Fingerprint reader (fprintd), firewalld
- **Firmware**: Custom DSDT overlay for Honor laptop

Based on [Dammyr nixos-laptops-config](https://github.com/DamyrFr/nixos-laptops-config/tree/main)

## Structure

```
.
├── flake.nix              # Main flake entry
├── modules/
│   ├── honor/              # Machine-specific (honor)
│   │   ├── configuration.nix
│   │   ├── hardware.nix
│   │   └── default.nix
│   ├── home/               # Home-manager user config
│   │   └── home.nix
│   └── features/           # Feature modules (niri, etc.)
│       └── niri.nix
```

## Building

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#honor

# Update dependencies
nix flake update
```
