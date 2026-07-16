{
  lib,
  buildGoModule,
  fetchFromGitLab,
  ...
}:
let
  rev = "49b20cf372fbe1727e0c86da08a4ef6dbeb50376";
in
buildGoModule (finalAttrs: {
  pname = "webwing";
  version = rev;

  src = fetchFromGitLab {
    owner = "Simsva";
    repo = "webwing";
    inherit rev;
    sha256 = "sha256-PxrhZksk33j8UaG1eyBevd3gr1vLJqGDcEcMspusidc=";
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
