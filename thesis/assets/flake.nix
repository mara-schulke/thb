{
  description = "Plotting Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fonts = {
      url = "git+ssh://git@github.com/hemisphere-systems/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      fonts,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fonts.overlays.default ];
        };

        juliaWithPackages = pkgs.julia.withPackages [
          "Plots"
          "PyPlot"
          "StatsPlots"
          "TOML"
          "ColorSchemes"
          "ArgParse"
        ];

        berkeleyMonoPath = "${pkgs.berkeley-mono}/share/fonts/truetype/berkeley-mono";

        render = pkgs.writeShellScriptBin "render" ''
          export BERKELEY_MONO_PATH="${berkeleyMonoPath}"
          ${juliaWithPackages}/bin/julia bin/render "$@"
        '';

        assets = pkgs.stdenv.mkDerivation {
          name = "assets";
          src = ./.;

          buildInputs = [ juliaWithPackages ];

          buildPhase = ''
            export HOME=$TMPDIR
            export BERKELEY_MONO_PATH="${berkeleyMonoPath}"
            ${juliaWithPackages}/bin/julia bin/render --results var/conf/benchmark.toml --plots var/conf/plots.toml
          '';

          installPhase = ''
            mkdir -p $out
            cp -r out/* $out/
          '';
        };
      in
      {
        packages = {
          default = assets;
          assets = assets;
          render = render;
        };

        apps = {
          default = {
            type = "app";
            program = "${render}/bin/render";
          };
          render = {
            type = "app";
            program = "${render}/bin/render";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            juliaWithPackages
          ];
          shellHook = ''
            export BERKELEY_MONO_PATH="${berkeleyMonoPath}"
          '';
        };
      }
    );
}
