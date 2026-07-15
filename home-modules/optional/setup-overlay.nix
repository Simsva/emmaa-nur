{
  inputs,
  ...
}:
{
  imports = import ../module-list.nix;
  config.nixpkgs.overlays = [ inputs.self.overlays.default ];
}
