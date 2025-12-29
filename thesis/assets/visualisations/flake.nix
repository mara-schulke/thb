{
  description = "Plotting Environment";

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

        render = pkgs.writeShellScriptBin "render" ''
          ${juliaWithPackages}/bin/julia bin/render "$@"
        '';
      in
      {
        packages = {
          default = render;
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
        };
      }
    );
}
