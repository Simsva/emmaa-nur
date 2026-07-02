{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
}:
let
  rev = "691cad0cb0d58242130ff3c63c8217c39a75fd72";
in
stdenvNoCC.mkDerivation rec {
  pname = "ics-splitter";
  version = rev;

  src = fetchFromGitLab {
    owner = "Simsva";
    repo = "ics-splitter";
    inherit rev;
    sha256 = "sha256-AaF0BsMzdiH8Ka09JWbqU0B9CDzwikkyXm3rzcTh7QQ=";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R ./src/* $out/
  '';

  meta = {
    description = "A proxy for pre-processing events from iCalendar URLs";
    license = lib.licenses.bsd3;
  };
}
