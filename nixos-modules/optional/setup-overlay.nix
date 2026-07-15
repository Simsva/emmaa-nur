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
  config.nixpkgs.overlays = [ inputs.self.overlays.default ];
}
