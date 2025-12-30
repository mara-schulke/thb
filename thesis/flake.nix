{
  description = "Applied Graph Kernels for Schema-Aware In-Context Learning in NL2SQL";

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

        render = pkgs.writeShellApplication {
          name = "render";
          buildInputs = [
            pkgs.pdflatex
            pkgs.inkscape
          ];
          text = ''
            ${pkgs.pdflatex}/bin/pdflatex --shell-escape "$@"
          '';
        };

        thesis = pkgs.stdenv.mkDerivation {
          name = "thesis";
          src = ./.;

          buildInputs = [ render ];

          buildPhase = ''
            rm -rf assets
            mkdir -p assets/out
            cp -r ${assets} assets/out
            ${render}/bin/render
          '';

          installPhase = ''
            mkdir -p $out
            cp thesis.pdf $out
          '';
        };
      in
      {
        packages = {
          default = thesis;
          thesis = thesis;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.inkscape
            assets.packages.${system}.default
          ];
        };
      }
    );
}
