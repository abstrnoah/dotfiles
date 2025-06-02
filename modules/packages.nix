# Organise flake packages.

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
  upstreamPackagesModule = mkTransposedPerSystemModule {
    name = "upstreamPackages";
    option = mkOption {
      type = types.lazyAttrsOf types.package;
      default = { };
      description = ''
        All upstream packages your flake uses.
      '';
    };
    file = ./packages.nix;
  };
  # TODO There's probably a way to avoid this
  ourPackagesModule = mkTransposedPerSystemModule {
    name = "ourPackages";
    option = mkOption {
      type = types.lazyAttrsOf types.package;
      default = { };
      description = ''
        Packages your flake creates or overrides.
      '';
    };
    file = ./packages.nix;
  };
  packageCollectionsModule = mkTransposedPerSystemModule {
    name = "packageCollections";
    option = mkOption {
      type = types.lazyAttrsOf (types.lazyAttrsOf types.package);
      default = { };
      description = ''
        A collection of package collections.
      '';
    };
    file = ./packages.nix;
  };

  module = {
    imports = [
      upstreamPackagesModule
      ourPackagesModule
      packageCollectionsModule
    ];

    config.perSystem =
      { config, ... }:
      {
        config.packages = (config.upstreamPackages or { }) // (config.ourPackages or { });
      };
  };
in
{
  config.flake.modules.flake.packages = module;
  imports = [ module ];
}
