{
  inputs,
  ...
}:
{
  imports = import ../base/module-list.nix;
  config.nixpkgs.overlays = [ inputs.self.overlays.default ];
}
