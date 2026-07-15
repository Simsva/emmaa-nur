{
  pkgs,
  lib,
  mode,
  inputs,
}:
rec {
  ifNotCI = p: if mode == "ci" then null else p;
  ifNotNUR = p: if mode == "nur" then null else p;

  # Overwrite callPackage to include packages from this repo
  mkCallPackage =
    _packages:
    lib.callPackageWith (
      pkgs
      // _packages
      // rec {
        inherit
          _packages
          inputs
          ;
      }
    );

  # Valid dependencies for default.nix in a group
  mkCallGroupDeps =
    _packages: callPackage:
    let
      loadPackages = mkLoadPackages callPackage;
    in
    {
      inherit
        _packages
        callPackage
        mkCallPackage
        mkLoadPackages
        ifNotCI
        ifNotNUR
        inputs
        lib
        loadPackages
        mode
        pkgs
        ;
    };

  # Call a group of packages with the correct dependencies
  mkCallGroup =
    _packages: callPackage: path:
    lib.recurseIntoAttrs (pkgs.callPackage path (mkCallGroupDeps _packages callPackage));

  # Call all packages in directory. Each package has to be a separate directory
  mkLoadPackages =
    callPackage: path: mapping:
    lib.genAttrs
      (builtins.filter (v: !(lib.hasSuffix ".nix" v)) (builtins.attrNames (builtins.readDir path)))
      (
        n:
        let
          pkg = callPackage (path + "/${n}") { };
        in
        (mapping."${n}" or lib.id) pkg
      );

  _doGroupPackages =
    callGroup: groups: lib.mapAttrs (_: callGroup) (lib.filterAttrs (_: v: !isNull v) groups);

  doFlatGroupPackages =
    _packages: groups:
    let
      callPackage = mkCallPackage _packages;
      callGroupDeps = mkCallGroupDeps _packages callPackage;
      callGroup = p: import p callGroupDeps;
    in
    _doGroupPackages callGroup groups;

  doGroupPackages =
    _packages: groups:
    let
      callPackage = mkCallPackage _packages;
      callGroup = mkCallGroup _packages callPackage;
    in
    _doGroupPackages callGroup groups;
}
