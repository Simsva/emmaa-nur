# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `overlays`,
# `nixosModules`, `homeModules`, `darwinModules` and `flakeModules`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

# Mode:
#  - null: default
#  - "legacy": from legacyPackages
#  - "nur": from NUR bot
mode:
{
  pkgs ? import <nixpkgs> { },
  inputs ? null,
}:
let
  inherit (pkgs) lib;
  inherit
    (import ../helpers/group.nix {
      inherit
        pkgs
        lib
        mode
        inputs
        ;
    })
    doFlatGroupPackages
    doGroupPackages
    ;

  flatGroups = {
    # Packages in the "root"
    uncategorized = ./uncategorized;
  };

  groups = {
    # Subcategories of packages
  };

  self = lib.foldl (a: b: a // b) (doGroupPackages self groups) (
    builtins.attrValues (doFlatGroupPackages self flatGroups)
  );
in
self
