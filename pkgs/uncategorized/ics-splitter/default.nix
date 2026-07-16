{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  ...
}:
let
  rev = "28a9c69cd268edebe4d06b8cd8ee26637fb4d17d";
in
stdenvNoCC.mkDerivation rec {
  pname = "ics-splitter";
  version = rev;

  src = fetchFromGitLab {
    owner = "Simsva";
    repo = "ics-splitter";
    inherit rev;
    sha256 = "sha256-CJuQ/3AJHU3C66496OLcB5pz+12bF8w9Wzt0zDTq2j8=";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R ./src/* $out/
  '';

  meta = {
    description = "A proxy for pre-processing events from iCalendar URLs";
    homepage = "https://gitlab.com/Simsva/ics-splitter";
    license = lib.licenses.bsd3;
  };
}
