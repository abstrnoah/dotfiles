top@{
  config,
  library,
  flake-parts-lib,
  ...
}:
let
  perSystemOutputModule = flake-parts-lib.mkTransposedPerSystemModule {
    name = "utilities";
    option = library.mkOption {
      type = library.types.lazyAttrsOf library.types.anything;
      default = { };
      description = "utilities are not system-agnostic!";
    };
    file = ./utilities.nix;
  };
in
{
  imports = [ perSystemOutputModule ];

  perSystem =
    { pkgs, ... }:
    let
      utilities = import ../utilities.nix {
        inherit library;
        nixpkgs = pkgs;
      };
    in
    {
      inherit utilities;
      _module.args.utilities = utilities;
    };

  flake.nixosModules.base =
    { system, ... }:
    {
      _module.args.utilities = top.config.flake.utilities.${system};
    };
}
