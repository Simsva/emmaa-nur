{
  inputs,
  ...
}:
{
  imports = import ../home/module-list.nix;
  config.nixpkgs.overlays = [ inputs.self.overlays.default ];
}
