{
  description = "AdNauseam Chromium extension — unpacked";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
          version = "3.28.2";
          hash = "sha256-aiBPUw7J7jaVaPd1eyEcZkIPhAAWP0RkA85GfNVlpnc=";
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
