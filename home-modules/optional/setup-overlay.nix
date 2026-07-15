{
  inputs,
  lib,
  ...
}:
{
  imports = import ../home/module-list.nix lib;
  config.nixpkgs.overlays = [ inputs.self.overlays.default ];
}
