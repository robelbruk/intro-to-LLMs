{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3Packages.pip
            python3Packages.virtualenv
            python3Packages.setuptools
            python3Packages.wheel
          ];

          shell = "${pkgs.zsh}/bin/zsh";

          shellHook = ''
            export PYTHONNOUSERSITE="true"
            test -d .nix-venv || python3 -m venv .nix-venv
            source .nix-venv/bin/activate
            echo ".nix-venv activated ✅. pip install packages like numpy, jupyter, etc."
          '';
        };
      }
    );
}