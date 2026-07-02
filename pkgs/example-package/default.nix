{ stdenv }:

stdenv.mkDerivation rec {
  name = "example-package-${version}";
  version = "1.1";
  src = ./.;
  buildPhase = ''
    cat <<EOF > example
    #!/usr/bin/env bash
    echo "Hello, world!"
    EOF
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 example $out/bin
  '';
}
