{
  description = "AdNauseam Chromium extension — unpacked";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          version = "3.28.8";
          hash = "sha256-+BRtcnOk+jx9zMKc0+m5cUpYNLpgYeuJKBk57otK2VA=";
          adnauseam = pkgs.fetchzip {
            pname = "adnauseam";
            url = "https://github.com/dhowe/AdNauseam/releases/download/v${version}/adnauseam-${version}.chromium.zip";
            inherit version hash;
          };
        in
        {
          inherit adnauseam;
          default = adnauseam;
        }
      );

      nixosModules.default =
        { pkgs, ... }:
        {
          systemd.tmpfiles.rules = [
            "L+ /run/adnauseam.chromium - - - - ${self.packages.${pkgs.stdenv.hostPlatform.system}.adnauseam}"
          ];
        };
    };
}
