flakeInputs:
{
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./add-modules.nix
  ];
  config.nixpkgs.overlays = [ flakeInputs.self.overlays.default ];
}
