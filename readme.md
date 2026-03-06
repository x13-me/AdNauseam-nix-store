# AdNauseam-nix-store

Provides [AdNauseam](https://adnauseam.io/) in the nix store, to permit Chromium-based browsers to `Load Unpacked Extensions` from a gc-safe location.

Primarily intended for use with [Helium](https://github.com/x13-me/helium-nix), which ships with uBlock by default.

## Usage

Add to your flake inputs:

```nix
inputs = {
  adnauseam.url = "github:x13-me/AdNauseam-nix-store";
  adnauseam.inputs.nixpkgs.follows = "nixpkgs";
};
```

Then import the module wherever appropriate in your NixOS config:

```nix
imports = [
  inputs.adnauseam.nixosModules.default
];
```

After rebuilding, `/run/adnauseam.chromium` will be a symlink to the extension in the Nix store.