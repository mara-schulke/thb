{
  description = "Thesis Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    assets.url = "path:assets";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      assets,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.inkscape
            assets.packages.default
          ];
        };
      }
    );
}
