{ inputs, ... }:
{
  imports = [ inputs.brumalpkgs.flakeModules.default ];
  config.brumalpkgs.enable = false;
}
