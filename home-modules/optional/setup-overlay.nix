flakeInputs:
{
  inputs,
  lib,
  ...
}:
{
  imports = [
    (import ./add-modules.nix flakeInputs)
  ];
  config.nixpkgs.overlays = [ flakeInputs.self.overlays.default ];
}
