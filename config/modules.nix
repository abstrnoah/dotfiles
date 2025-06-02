{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (builtins)
    attrValues
    ;
in
{
  # Bring library modules into flake.
  imports = [ (inputs.import-tree ../modules) ];

  # TODO
  # # TODO This sort of thing should maybe be automated? Or maybe I'm misusing this pattern?
  # config.flake.flakeModules = config.flake.modules.flake;
}
