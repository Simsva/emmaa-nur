{
  inputs,
  lib,
  ...
}:
{
  imports = import ../base/module-list.nix lib;
  config.nixpkgs.overlays = [ inputs.self.overlays.default ];
}
