{
  lib,
  buildGoModule,
  fetchFromEmmaa,
  ...
}:
let
  rev = "56636446a93cddb9ad2b58ad491d3160dc7a02c8";
in
buildGoModule (finalAttrs: {
  pname = "shallot";
  version = rev;

  src = fetchFromEmmaa {
    repo = "shallot";
    inherit rev;
    sha256 = "sha256-J8kyjP5I0XFrxHJJM/VvJK0K5lBg5XrLvveuqQYW9HY=";
  };

  vendorHash = null;

  postBuild = ''
    mkdir -p $out/examples
    cp ./index.html.example $out/examples/index.html
  '';

  meta = {
    description = "A really simple webring server that generates a homepage with 88x31 buttons.";
    homepage = "https://git.emmaa.tech/emma/shallot";
    license = lib.licenses.bsd3;
  };
})
