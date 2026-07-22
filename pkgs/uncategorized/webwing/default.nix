{
  lib,
  buildGoModule,
  fetchFromGitLab,
  ...
}:
let
  rev = "7b41ca8cba740a4528186e5a7cf5bf6e819c8749";
in
buildGoModule (finalAttrs: {
  pname = "webwing";
  version = rev;

  src = fetchFromGitLab {
    owner = "Simsva";
    repo = "webwing";
    inherit rev;
    sha256 = "";
  };

  vendorHash = null;

  postBuild = ''
    mkdir -p $out/examples
    cp ./index.html.example $out/examples/index.html
  '';

  meta = {
    description = "A really simple webring server that generates a homepage with 88x31 buttons.";
    homepage = "https://gitlab.com/Simsva/webwing";
    license = lib.licenses.bsd3;
  };
})
