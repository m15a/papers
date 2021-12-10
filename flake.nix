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
        buildInputs = [
          (final.python3.withPackages (ps: [ ps.bibtexparser ]))
        ];
      } ''
        mkdir -p $out/bin
        install ${./bin/muzzle-bibfile} -m 755 $out/bin/muzzle-bibfile
        patchShebangs $out/bin/muzzle-bibfile
      '';

      # Don't forget to delete cache after bumping revision: $(pubsdir)/.cache
      pubs = prev.pubs.overridePythonAttrs (old: {
        version = "2021-11-22";
        src = final.fetchFromGitHub {
          owner = "pubs";
          repo = "pubs";
          rev = "4ec4ba0390ef6176687326f2f8b5a2c923dfa47b";
          sha256 = "sha256-0y6dXgkFZYVsbDlYX+FEhChQRPXhwNHNPCrYQNcWclo=";
        };
        buildInputs = (old.buildInputs or []) ++ [
          final.installShellFiles
        ];
        postInstall = ''
          register="${final.python3.pkgs.argcomplete}/bin/register-python-argcomplete"
          "$register" --shell bash pubs > pubs.bash
          "$register" --shell fish pubs > pubs.fish
          installShellCompletion --bash --name pubs.bash pubs.bash
          installShellCompletion --fish --name pubs.fish pubs.fish
        '';
      });

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
      pubs
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
