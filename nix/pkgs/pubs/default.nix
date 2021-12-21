{ pubs, fetchFromGitHub, installShellFiles, argcomplete }:

pubs.overridePythonAttrs (old: {
  version = "2021-11-22";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "4ec4ba0390ef6176687326f2f8b5a2c923dfa47b";
    sha256 = "sha256-0y6dXgkFZYVsbDlYX+FEhChQRPXhwNHNPCrYQNcWclo=";
  };

  buildInputs = (old.buildInputs or []) ++ [
    installShellFiles
  ];

  patches = (old.patches or []) ++ [
    ./pubs.patch
    ./commit-message.patch
  ];

  postInstall = (old.postInstall or "") + ''
    register="${argcomplete}/bin/register-python-argcomplete"
    "$register" --shell bash pubs > pubs.bash
    "$register" --shell fish pubs > pubs.fish
    installShellCompletion --bash --name pubs.bash pubs.bash
    installShellCompletion --fish --name pubs.fish pubs.fish
  '';

  meta = old.meta // {
    description = old.meta.description + " (patched: https://github.com/pubs/pubs/pull/273)";
  };
})
