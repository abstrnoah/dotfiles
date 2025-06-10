{
  lib,
  flake-parts-lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  inherit (flake-parts-lib)
    mkTransposedPerSystemModule
    ;
  module = mkTransposedPerSystemModule {
    name = "library";
    option = mkOption {
      type = types.lazyAttrsOf types.anything;
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
  imports = [ module ];

  config.perSystem =
    {
      config,
      system,
      pkgs,
      ...
    }:
    let
      library = import ../library.nix {
        inherit system;
        nixpkgs = pkgs;
      };
    in
    {
      config.library = library;
      config._module.args.library = library;
    };
}
