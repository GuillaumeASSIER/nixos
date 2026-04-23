# Migration vers le dendritic pattern — TERMINEE

## Principe

Le dendritic pattern utilise le Nixpkgs module system comme configuration top-level. Chaque fichier Nix (sauf `flake.nix`) est un module top-level (flake-parts), et les configurations NixOS et home-manager sont stockées comme `deferredModule`.

Chaque module top-level :
- implémente une seule feature
- à travers toutes les configurations où elle s'applique
- est à un chemin qui nomme cette feature

## Structure cible

```
.
├── flake.nix                      # Point d'entree minimal (flake-parts + import-tree)
├── modules/
│   ├── meta.nix                   # Options top-level (secrets, emails, vars)
│   ├── infra.nix                  # Configurations NixOS + HM + outputs
│   ├── devshell.nix               # Dev shell
│   │
│   │── # ── Features NixOS ──
│   ├── core.nix                   # rtkit, ssh, netbird, zsh
│   ├── desktop.nix                # GNOME + GDM + PipeWire + Flatpak
│   ├── plasma.nix                 # KDE Plasma + SDDM + PipeWire
│   ├── browser.nix                # Firefox & Chromium policies
│   ├── ide.nix                    # git, lazygit, opencode
│   ├── security.nix               # AppArmor, fail2ban, firewall
│   ├── journald.nix               # Journald config
│   ├── office.nix                 # LibreOffice, Thunderbird, etc.
│   ├── k3s.nix                    # K3s server
│   ├── secureboot.nix             # Lanzaboote + Secure Boot
│   ├── debug.nix                  # htop, btop, wireshark, etc.
│   ├── intel.nix                  # Intel GPU tools
│   ├── pam-fix.nix                # Fix PAM/AppArmor
│   ├── pam.nix                    # Patched PAM module (upstream, ne pas modifier)
│   │
│   │── # ── Features Home-Manager ──
│   ├── codium.nix                 # VSCodium config (HM)
│   ├── shell.nix                  # tmux + zsh + zoxide (HM)
│   ├── ssh.nix                    # SSH config (HM)
│   │
│   │── # ── Assemblages hosts ──
│   ├── honor.nix                  # Host honor + config specifique
│   ├── pro.nix                    # Host pro + config specifique
│   ├── honor-disko.nix            # Partitionnement honor
│   ├── pro-disko.nix              # Partitionnement pro
```

## Decisions

| Question | Choix |
|---|---|
| Secrets/env vars | Options top-level impures dans `meta.nix` |
| Config inline par host | Reste dans le module d'assemblage (`honor.nix`, `pro.nix`) |
| Home-manager | `deferredModule` dans `configurations.nixos` |
| Infrastructure | `flake-parts` + `import-tree` |
| Structure | Tous les modules dans `modules/`, auto-importes |

---

## Phase 1 — Infrastructure (fondations)

### 1.1 Ajouter les inputs flake-parts et import-tree

```nix
flake-parts.url = "github:hercules-ci/flake-parts";
flake-parts.inputs.nixpkgs.follows = "nixpkgs";
import-tree.url = "github:vic/import-tree";
```

### 1.2 Recrire `flake.nix` — Point d'entree minimal

```nix
{
  description = "Guillaume NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    import-tree.url = "github:vic/import-tree";
    alejandra.url = "github:kamadorueda/alejandra";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:GuillaumeASSIER/nixos-hardware/thinkpad-t14s-gen6";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
```

Plus de `mkHost`, plus de liste manuelle d'imports. Tout est auto-importe.

### 1.3 Creer `modules/meta.nix`

Declare les options top-level qui remplacent `builtins.getEnv` disperses et `specialArgs` :

```nix
{ lib, ... }: {
  options = {
    heap.email = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "HEAP_EMAIL";
    };
    guillaume.email = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "GUILLAUME_EMAIL";
    };
    openwebui.apiUrl = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "OPENWEBUI_API_URL";
    };
    openwebui.apiKey = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "OPENWEBUI_API_KEY";
    };
    vates.gitHost = lib.mkOption {
      type = lib.types.str;
      default = builtins.getEnv "VATES_GIT_HOST";
    };
  };
}
```

Tout module peut lire `config.heap.email` au lieu de `builtins.getEnv`.

### 1.4 Creer `modules/infra.nix`

Coeur du pattern. Declare `configurations.nixos` avec `deferredModule`, genere les `nixosConfigurations`, integre home-manager, et les outputs packs/devshells/checks :

```nix
{ lib, config, inputs, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options = {
        module = lib.mkOption {
          type = lib.types.deferredModule;
        };
        home-manager = lib.mkOption {
          type = lib.types.attrsOf lib.types.deferredModule;
          default = {};
        };
      };
    });
  };

  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
      name: cfg:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            cfg.module
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users = lib.flip lib.mapAttrs cfg.home-manager (
                  username: hm: hm
                );
              };
            }
          ];
        };
    );
  };

  config.devShells.${builtins.currentSystem}.default =
    inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.mkShell {
      buildInputs = [
        inputs.alejandra.defaultPackage.${builtins.currentSystem}
        inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.statix
        inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.deadnix
      ];
    };

  config.flake.formatter.${builtins.currentSystem} =
    inputs.alejandra.defaultPackage.${builtins.currentSystem};

  config.flake.packages.${builtins.currentSystem} = {
    inherit (inputs.nixpkgs.legacyPackages.${builtins.currentSystem}) alejandra statix deadnix;
    default = inputs.self.packages.${builtins.currentSystem}.alejandra;
  };

  config.flake.checks = lib.flip lib.mapAttrs config.flake.nixosConfigurations (
    name: nixos: {
      ${nixos.config.nixpkgs.hostPlatform.system}."configurations:nixos:${name}" =
        nixos.config.system.build.toplevel;
    };
  );
}
```

---

## Phase 2 — Convertir les feature modules NixOS

Chaque module existant dans `modules/features/*.nix` est enveloppe dans `flake.modules.nixos.<name>`.

Transformation mecanique :

| Avant | Apres |
|---|---|
| `{pkgs, ...}: { services.flatpak.enable = true; }` | `{pkgs, ...}: { flake.modules.nixos.desktop = { services.flatpak.enable = true; }; }` |

Fichiers a convertir :
- `core.nix`, `desktop.nix`, `plasma.nix`, `browser.nix`, `ide.nix`
- `security.nix`, `journald.nix`, `office.nix`, `k3s.nix`
- `secureboot.nix`, `debug.nix`, `intel.nix`

Le fix PAM (`modules/fixes/pam-apparmor-include-substack.nix`) devient `modules/pam-fix.nix` :

```nix
{...}: {
  flake.modules.nixos.pam-fix = {
    disabledModules = ["security/pam.nix"];
    imports = [./pam.nix];
  };
}
```

> `modules/pam.nix` (le fichier patch de 2656 lignes) reste a cote, reference par chemin relatif.

---

## Phase 3 — Assembler les hosts

### `modules/honor.nix`

```nix
{ config, pkgs, lib, inputs, ... }: let
  inherit (config.flake.modules) nixos home-manager;
in {
  configurations.nixos.honor = {
    module = {
      imports = with nixos; [
        core desktop ide browser security journald office k3s secureboot debug intel pam-fix
      ] ++ [
        inputs.disko.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
      ];

      # Config specifique honor (hostname, packages, programmes, swap, nix.gc, locales, etc.)
      nixpkgs.hostPlatform = "x86_64-linux";
      nixpkgs.config.allowUnfree = true;
      networking.hostName = "honor";
      # ... (reste du config issu de inventaire/hosts/honor/configuration.nix)

      # Hardware + disko inline ou importees
      imports ++ [ ./honor-disko.nix ];
      # ... hardware config
    };

    home-manager.heap = {
      imports = with home-manager; [ codium shell ssh ];
      home.stateVersion = "25.11";
      # ... packages specifiques heap, dconf, zed-editor, etc.
    };
  };
}
```

### `modules/pro.nix`

Meme pattern avec les features adequate (core, plasma, ide, browser, secureboot, k3s, debug).

### Hardware/Disko

`honor-disko.nix` et `pro-disko.nix` contiennent le config disko existant. Le hardware config est soit inline soit dans des modules separes.

---

## Phase 4 — Convertir home-manager en deferredModule

Les configs HM actuelles sont decoupees en features :

| Feature | Source | Contenu |
|---|---|---|
| `modules/codium.nix` | `modules/home/codium.nix` | VSCodium config |
| `modules/shell.nix` | `heap/home.nix` + `guillaume/home.nix` | tmux, zsh, zoxide |
| `modules/ssh.nix` | `heap/home.nix` + `guillaume/home.nix` | SSH config |

Chaque feature HM :

```nix
# modules/codium.nix
{...}: {
  flake.modules.home-manager.codium = {
    programs.vscode = { ... };
  };
};
```

Le config par utilisateur specifique (packages perso, dconf, zed-editor) reste dans le module d'assemblage du host.

---

## Phase 5 — Nettoyage

1. **Supprimer** : `inventaire/`, `modules/features/`, `modules/fixes/`, `modules/home/`, `shell.nix` — **FAIT**
2. **Garder** : `patches/pam.nix` (fichier patch upstream de 2656 lignes) — **FAIT**
3. **Aplatir** : `modules/features/*` et `modules/hosts/*` deplaces vers `modules/` — **FAIT**
4. **Mettre a jour** `AGENTS.md` avec la nouvelle structure — **FAIT**
5. **Tester** : `nix flake check --impure` et `nixos-rebuild build --impure --flake .#honor` — **FAIT**

---

## Ordre d'execution

1. Phase 1 (infra) — le socle
2. Phase 2 (features NixOS) — conversion mecanique
3. Phase 3 (assemblage hosts) — brancher les hosts
4. Phase 4 (home-manager) — integrer HM en deferredModule
5. Phase 5 (nettoyage) — supprimer l'ancien arbre

Chaque phase peut etre testee independamment avec `nixos-rebuild build --impure --flake .#honor`.