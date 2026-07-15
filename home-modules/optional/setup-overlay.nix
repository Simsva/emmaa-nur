flakeInputs:
{
  inputs,
  lib,
  ...
}:
{
  imports = import ../base/module-list.nix {
    inherit
      lib
      ;
  };
  config.nixpkgs.overlays = [ flakeInputs.self.overlays.default ];
}
