{ pubs, fetchFromGitHub, installShellFiles, argcomplete }:

pubs.overridePythonAttrs (old: {
  version = "2022-01-05";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "bf79085e3876fb764ee194be7c35b7207e9a7d70";
    sha256 = "sha256-/K9QcLlqSS7qYQalmoBXNfEXnWYwACyixpctcCT/RVM=";
  };

  buildInputs = (old.buildInputs or []) ++ [
    installShellFiles
  ];

  patches = (old.patches or []) ++ [
    ./commit-message.patch
  ];

  postInstall = (old.postInstall or "") + ''
    register="${argcomplete}/bin/register-python-argcomplete"
    "$register" --shell bash pubs > pubs.bash
    "$register" --shell fish pubs > pubs.fish
    installShellCompletion --bash --name pubs.bash pubs.bash
    installShellCompletion --fish --name pubs.fish pubs.fish
  '';
})
