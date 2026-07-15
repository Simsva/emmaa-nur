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
  config.nixpkgs.overlays = [ inputs.self.overlay ];
}
