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
  pubs = final.callPackage ./pkgs/pubs {
    pubs = prev.pubs;
    inherit (final.python3.pkgs) argcomplete;
  };

  papersEnv = final.buildEnv {
    name = "papers-env";
    paths = with final; [
      pubs
      muzzle-bibfile
    ];
  };
}
