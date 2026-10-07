{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  gnused,
  qt6Packages,
  ...
}:
stdenv.mkDerivation rec {
  pname = "serialplot";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hyOzd";
    repo = "serialplot";
    rev = "ae7e3dc1f7bbd308a6a3a815d704444966b59c65";
    sha256 = "sha256-dmkKdfU92ahZRxYS56IbC9Jc9YoBbsyELuz+RLZtoAk=";
  };

  nativeBuildInputs = [
    cmake
    gnused
    qt6.qmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6Packages.qwt
    qt6.qtbase
    qt6.qtserialport
    qt6.qtsvg
  ];

  patchPhase = ''
    sed -i 's/BUILD_QWT true/BUILD_QWT false/g' CMakeLists.txt
  '';

  meta = {
    description = "Small and simple software for plotting data from serial port in realtime.";
    homepage = "https://hackaday.io/project/5334-serialplot-realtime-plotting-software";
    license = lib.licenses.gpl3;
  };
}
