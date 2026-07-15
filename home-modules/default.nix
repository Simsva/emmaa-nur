{
  lib,
  flakeInputs,
  ...
}:
with builtins;
let
  dir = ./optional;
  optionals = attrNames (readDir dir);
in
listToAttrs (
  map (m: {
    name = lib.toCamelCase (lib.removeSuffix ".nix" m);
    value = import (dir + "/${m}") flakeInputs;
  }) optionals
)
