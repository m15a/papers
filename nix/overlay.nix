final: prev:

{
  muzzle-bibfile = final.callPackage ./pkgs/muzzle-bibfile.nix {};

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
