{
  description = "m15a/papers flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShell = pkgs.mkShell {
      buildInputs = [
        (pkgs.python3.withPackages (ps: [
          ps.black
          ps.isort
          ps.bibtexparser
        ]))
        pkgs.pyright
      ];
    };
  });
}
