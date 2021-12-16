{
  description = "m15a/papers flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  {
    overlay = import ./nix/overlay.nix;
  } // flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      overlays = [ self.overlay ];
      inherit system;
    };

    pythonDevEnv = pkgs.python3.withPackages (ps: [
      ps.pybtex
      ps.black
      ps.isort
      ps.flake8
      ps.pre-commit
    ]);
  in
  {
    packages = {
      inherit (pkgs)
      muzzle-bibfile
      pubs
      papersEnv;
    };

    defaultPackage = pkgs.papersEnv;

    devShell = pkgs.mkShell {
      buildInputs = [
        pythonDevEnv
        pkgs.pyright
      ];
    };
  });
}
