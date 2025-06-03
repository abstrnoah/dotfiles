{ lib, flake-parts-lib, pkgs, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
  inherit (flake-parts-lib)
    mkTransposedPerSystemModule
    ;
  transposeModule = mkTransposedPerSystemModule {
    name = "legacyDotfiles";
    option = mkOption {
      type = types.lazyAttrsOf types.package;
      description = ''
        A shim to continue using my old-style dotfiles whilst I slowly migrate to pure nixos.
      '';
      default = { };
    };
    file = ./legacy.nix;
  };
in
{
  imports = [ transposeModule ];

  config.perSystem =
    { config, ... }:
    let
      username = "abstrnoah"; # TODO move to meta
      inherit (config.library)
        storeSource
        mergePackages
        ;
      mkSource = name: storeSource { source = lib.path.append ../src name; };

      packagesWithSources = [
        "dict"
        "ttdl"
      ];
      collections = {
        coyote = [
          "dict"
          "ttdl"
        ];
      };
    in
    {
      config.legacyDotfiles = lib.attrsets.genAttrs packagesWithSources mkSource;
      # config.flake.modules.nixos.base.users.users.${username}.packages = builtins.map (
      #   name: config.packages.${name}
      # ) packagesWithSources;
    };

  config.flake.testout = pkgs.hello;
}
