top@{ flake-parts-lib, library, ... }:
let
  utilitiesPSM = flake-parts-lib.mkTransposedPerSystemModule {
    name = "utilities";
    option = library.mkOption {
      type = library.types.anything;
    };
    file = ./utilties.nix;
  };
in
{

  # NOTE: We import utilities separately because, despite our best intentions,
  #       nixpkgs may differ between flake and nixos (viz. overlays).

  imports = [ utilitiesPSM ];

  perSystem =
    {
      pkgs,
      library,
      config,
      ...
    }:
    {
      _module.args.utilities = config.utilities;
      utilities = import ../../utilities.nix {
        inherit library;
        nixpkgs = pkgs;
      };
    };

  flake.nixosModules.brumal =
    { pkgs, library, ... }:
    {
      _module.args.utilities = import ../../utilities.nix {
        inherit library;
        nixpkgs = pkgs;
      };
    };
}
