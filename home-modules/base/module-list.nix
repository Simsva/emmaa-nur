{
  lib,
  ...
}:
lib.filter (n: baseNameOf n == "default.nix") (lib.filesystem.listFilesRecursive ./.)
