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

        texlive = pkgs.texlive.combined.scheme-full;

        thesis = pkgs.stdenv.mkDerivation {
          name = "thesis";
          src = ./.;

          buildInputs = [
            texlive
            pkgs.inkscape
          ];

          buildPhase = ''
            # Copy assets from the assets flake
            rm -rf assets/out
            mkdir -p assets/out
            cp -r ${assets.packages.${system}.default}/* assets/out/

            # Set HOME for inkscape
            export HOME=$TMPDIR

            # Run pdflatex multiple times for proper references and citations
            pdflatex -shell-escape -interaction=nonstopmode thesis.tex || true
            bibtex thesis || true
            pdflatex -shell-escape -interaction=nonstopmode thesis.tex || true
            pdflatex -shell-escape -interaction=nonstopmode thesis.tex || true

            # Verify PDF was created
            if [ ! -f thesis.pdf ]; then
              echo "ERROR: thesis.pdf was not created!"
              exit 1
            fi
          '';

          installPhase = ''
            mkdir -p $out
            cp thesis.pdf $out/
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
            texlive
            pkgs.inkscape
          ];
        };
      }
    );
}
