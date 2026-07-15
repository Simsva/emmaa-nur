# For when you useGlobalPkgs
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
}
