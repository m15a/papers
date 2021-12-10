{
  description = "m15a/papers flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
  {
    overlay = final: prev: {
      muzzle-bibfile = final.runCommandNoCC "muzzle-bibfile" {
        buildInputs = [ final.makeWrapper ];
      } (let
        ourPython3 = prev.python3.withPackages (ps: [ ps.bibtexparser ]);
      in ''
        mkdir -p $out/bin
        install ${./bin/muzzle-bibfile} -m 755 $out/bin/muzzle-bibfile
        wrapProgram $out/bin/muzzle-bibfile --prefix PATH : ${final.lib.makeBinPath [ ourPython3 ]}
      '');

      papersEnv = final.buildEnv {
        name = "papers-env";
        paths = with final; [
          pubs
          muzzle-bibfile
        ];
      };
    };
  } // flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      overlays = [ self.overlay ];
      inherit system;
    };

    pythonEnv = pkgs.python3.withPackages (ps: [
      ps.black
      ps.isort
      ps.pre-commit
    ]);
  in
  {
    packages = {
      inherit (pkgs)
      muzzle-bibfile
      papersEnv;
    };

    defaultPackage = pkgs.papersEnv;

    devShell = pkgs.mkShell {
      buildInputs = [
        pythonEnv
        pkgs.pyright
      ];
    };
  });
}
