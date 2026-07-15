flakeInputs:
{
  inputs,
  lib,
  ...
}:
{
  imports = import ../home/module-list.nix {
    inherit
      lib
      ;
  };
  config.nixpkgs.overlays = [ flakeInputs.self.overlays.default ];
}
