{ lib, runCommandNoCC, makeWrapper, python3 }:

let
  pythonEnv = python3.withPackages (ps: [ ps.pybtex ]);
in

runCommandNoCC "muzzle-bibfile" {
  buildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin/.unwrapped
  install ${../../bin/muzzle-bibfile} -m 755 $out/bin/.unwrapped/muzzle-bibfile
  makeWrapper \
  $out/bin/.unwrapped/muzzle-bibfile \
  $out/bin/muzzle-bibfile \
  --prefix PATH : ${lib.makeBinPath [ pythonEnv ]}
''
