{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };
    outputs = { self, nixpkgs, flake-utils, ... }:
        flake-utils.lib.eachDefaultSystem (system: 
          let 
            pkgs = import nixpkgs { inherit system; };
            envWithScript = pkgs.buildFHSUserEnv {
                name = "python-env";
                targetPkgs = pkgs: with pkgs; [
                    python3
                    python3Packages.pip
                    python3Packages.virtualenv
                    pythonManylinuxPackages.manylinux2014Package
                    cmake
                    ninja
                    gcc
                ];
                runScript = "${pkgs.writeShellScriptBin "runScript" ''
                  set -e
                  test -d .nix-venv || ${pkgs.python3.interpreter} -m venv .nix-venv
                  source .nix-venv/bin/activate
                  echo "You are now inside the FHS Python env. Install packages with pip."
                  exec bash
                ''}/bin/runScript";
            };
        in {
            devShell = envWithScript;
        } 
    ); 
}