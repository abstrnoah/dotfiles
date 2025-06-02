{ lib, flake-parts-lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
  inherit (flake-parts-lib)
    mkTransposedPerSystemModule
    ;
in
let
  module = mkTransposedPerSystemModule {
    name = "library";
    option = mkOption {
      type = types.lazyAttrsOf types.anything;
      default = { };
      default = { };
      description = ''
        A flake's per-system library output. Libraries are supposed to contain any reusable artefacts that aren't modules or apps.

        We use "library" instead of "lib" because the latter seems to be reserved for `nixpkgs.lib`. In particular, note how modules get an argument "lib"; that argument is destinguished not least because it provides the module primitives.

        We chose singular "library" to emphasise this is _not_ a collection of libraries, but rather a single library---one library per flake! This choice to avoid a proliferation of libraries.
      '';
    };
    file = ./library.nix;
  };
in
{
  config.flake.modules.flake.library = module;
  # TODO Annoyingly, if we want to import a library module, we have to do it here to avoid recursion. Look into avoiding this.
  imports = [ module ];
}
