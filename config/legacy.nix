# Pull in legacy dotfiles for use by nixphile
# As before, there will be package outputs `dotfiles#HOST` which get passed to nixphile.
# Add sources to a host by setting `config.perSystem = _: {config.brumal.legacyDotfiles.HOST = [ ... ]}`.

{ config, flake-parts-lib, ... }:
let
inherit (lib)
types;
inherit (flake-parts-lib)
mkPerSystemOption
mkOption;
{
  options.perSystem = mkPerSystemOption ({...}: {
  options.brumal.legacy-dotfiles = mkOption {
    type = types.listOf types.path;
    default = [];
    description = ''
      List of paths to sources that will get merged together and put into packa
    '';
  };
  }
  );
}
