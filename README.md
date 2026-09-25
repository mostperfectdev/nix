# Niko's NixOS Configuration

## Structure

```
├── flake.nix              # Main flake configuration
├── lib/
│   └── default.nix        # mkSystem & mkHome helpers
│
├── hosts/
│   ├── common/
│   │   ├── global/        # Mandatory for all hosts
│   │   │   ├── locale.nix
│   │   │   ├── nix.nix
│   │   │   ├── security.nix
│   │   │   ├── theme.nix
│   │   │   └── user.nix
│   │   └── optional/      # Feature flags (imported per-host)
│   │       ├── docker.nix
│   │       ├── niri.nix
│   │       └── filemanager.nix
│   ├── gom/               # ThinkPad T14s (desktop + dev)
│   ├── boldan/            # Server
│   └── barlow/            # Laptop
│
├── homes/niko/
│   ├── global/            # Mandatory for all hosts
│   │   ├── home.nix
│   │   ├── shell.nix
│   │   └── shell/         # Fish config & tools
│   ├── optional/          # Feature flags (imported per-host)
│   │   ├── desktop.nix    # Niri, Noctalia, etc
│   │   ├── dev.nix        # Work tools
│   │   └── desktop/
│   ├── gom.nix            # Host-specific imports
│   ├── boldan.nix
│   └── barlow.nix
│
├── pkgs/
│   └── catppuccin.nix     # Catppuccin theme configuration (imported by hosts/homes)
│
├── overlays/              # Package/module overrides (for future use)
│   └── README.md
│
└── modules/               # Custom NixOS/HM modules (for future use)
    ├── nixos/
    ├── home-manager/
    └── README.md
```

## Usage

### Build & Switch NixOS system
```bash
nh os switch .

nh os switch . --hostname gom
```

### Build & Switch Home Manager
```bash
nh home switch .
```

### View available configs
```bash
nix flake show
```

## Architecture

### Global vs Optional
- **Global**: Configuration applied to all systems (mandatory)
  - Core system services (nix, security, locale)
  - User setup and shell
  
- **Optional**: Feature flags enabled per host
  - Desktop environments (Niri)
  - Development tools
  - Optional services (docker, printing)

### Per-Host Customization
Each host:
1. Imports `../common/global/` (mandatory)
2. Imports specific features from `../common/optional/`
3. Adds host-specific configuration

Example `hosts/gom/default.nix`:
```nix
imports = [
  ../common/global
  ../common/optional/niri.nix
  ../common/optional/docker.nix
];
```

## Home Manager

Home Manager uses the same pattern:
- `homes/niko/global/` - Baseline (git, fish, keyring)
- `homes/niko/optional/` - Features (desktop, dev tools)
- `homes/niko/{hostname}.nix` - Host-specific imports

Example `homes/niko/gom.nix`:
```nix
imports = [
  ./optional/desktop.nix
  ./optional/dev.nix
];
```

## Adding a New Host

1. Create `hosts/newhost/default.nix`:
```nix
{ ... }:
{
  imports = [
    ../common/global
    ../common/optional/feature.nix
  ];
  networking.hostName = "newhost";
  # Add host-specific config
}
```

2. Create `hosts/newhost/hardware-configuration.nix` (from `nixos-generate-config`)

3. Create `homes/niko/newhost.nix`:
```nix
{ ... }:
{
  imports = [ ./optional/desktop.nix ];
}
```

4. Register in `flake.nix`:
```nix
newhost = mkSystem "newhost" { };
"niko@newhost" = mkHome { hostname = "newhost"; };
```
