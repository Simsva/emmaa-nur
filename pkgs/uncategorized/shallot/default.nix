{
  lib,
  buildGoModule,
  fetchFromEmmaa,
  ...
}:
let
  rev = "cd15596b1e194988e19d19988228a75ee9a1b7b2";
in
buildGoModule (finalAttrs: {
  pname = "shallot";
  version = rev;

  src = fetchFromEmmaa {
    repo = "shallot";
    inherit rev;
    sha256 = "sha256-i5Fkr+qyDBkcbDzLe29QKU9Ydw4haiSoYjo05ox33lU=";
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
