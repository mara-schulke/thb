{
  description = "Julia Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        juliaWithPackages = pkgs.julia.withPackages [
          "Plots"
          "PyPlot"
          "StatsPlots"
          "TOML"
          "ColorSchemes"
          "ArgParse"
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            juliaWithPackages
          ];
        };
      }
    );
}
