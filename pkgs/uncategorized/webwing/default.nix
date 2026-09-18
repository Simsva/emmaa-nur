{
  lib,
  buildGoModule,
  fetchFromEmmaa,
  ...
}:
let
  rev = "d80a313b585b54600ebd5ff98149c3de80ed86f4";
in
buildGoModule (finalAttrs: {
  pname = "webwing";
  version = rev;

  src = fetchFromEmmaa {
    repo = "webring";
    inherit rev;
    sha256 = "sha256-nx3KMnBSEsefWqllt60qLKJFjGgGuzkevfaEoQ4r1nM=";
  };

  vendorHash = null;

  postBuild = ''
    mkdir -p $out/examples
    cp ./index.html.example $out/examples/index.html
  '';

  meta = {
    description = "A really simple webring server that generates a homepage with 88x31 buttons.";
    homepage = "https://git.emmaa.tech/emma/webring";
    license = lib.licenses.bsd3;
  };
})
