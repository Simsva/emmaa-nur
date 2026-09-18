{
  lib,
  ...
}@inputs:
let
  helpers = [
    ./fetch.nix
  ];
in
lib.mergeAttrsList (map (x: import x inputs) helpers)
