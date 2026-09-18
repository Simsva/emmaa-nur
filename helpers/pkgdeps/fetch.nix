{
  pkgs,
  lib,
  mode,
  inputs,
  ...
}:
{
  fetchFromEmmaa =
    args:
    let
      args' = {
        domain = "git.emmaa.tech";
        owner = "emma";
      }
      // args;
    in
    pkgs.fetchFromForgejo args';
}
