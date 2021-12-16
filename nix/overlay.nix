final: prev:

{
  muzzle-bibfile = final.runCommandNoCC "muzzle-bibfile" {
    buildInputs = [ final.makeWrapper ];
  } (let
    ourPython3 = final.python3.withPackages (ps: [ ps.pybtex ]);
  in ''
    mkdir -p $out/bin/.unwrapped
    install ${./bin/muzzle-bibfile} -m 755 $out/bin/.unwrapped/muzzle-bibfile
    makeWrapper \
    $out/bin/.unwrapped/muzzle-bibfile \
    $out/bin/muzzle-bibfile \
    --prefix PATH : ${final.lib.makeBinPath [ ourPython3 ]}
  '');

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
    patches = (old.patches or []) ++ [ ../patches/pubs.patch ];
    postInstall = ''
      register="${final.python3.pkgs.argcomplete}/bin/register-python-argcomplete"
      "$register" --shell bash pubs > pubs.bash
      "$register" --shell fish pubs > pubs.fish
      installShellCompletion --bash --name pubs.bash pubs.bash
      installShellCompletion --fish --name pubs.fish pubs.fish
    '';
    meta = old.meta // {
      description = old.meta.description + " (patched: https://github.com/pubs/pubs/pull/273)";
    };
  });

  papersEnv = final.buildEnv {
    name = "papers-env";
    paths = with final; [
      pubs
      muzzle-bibfile
    ];
  };
}
