top@{ flake-parts-lib, library, ... }:
let
  inherit (library) mkOption types mapAttrs;
  psm = flake-parts-lib.mkTransposedPerSystemModule {
    name = "direnvs";
    option = mkOption {
      type = types.attrsOf direnvType;
    };
    file = ./direnv.nix;
  };
  direnvType = types.submodule ({
    options = {
      variables = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };
      packages = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
    };
    # We defer construction of the actual shell until we have access to system.
  });
  module = {
    imports = [ psm ];
    config.perSystem =
      { pkgs, config, ... }:
      let
        direnvToShell =
          name: value:
          pkgs.mkShellNoCC (
            {
              inherit name;
              inherit (value) packages;
            }
            // value.variables
          );
      in
      {
        devShells = mapAttrs direnvToShell config.direnvs;
      };
  };
in
{
  imports = [ module ];
  flake.flakeModules.direnvs = module;
}
