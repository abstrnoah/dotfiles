{
  lib,
  flake-parts-lib,
  moduleWithSystem,
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
  username = "abstrnoah"; # TODO move to meta
  packagesWithSources = [
    "dict"
    "ttdl"
    "curl"
    "git"
    "udiskie"
    "tmuxinator"
    "visidata"
    "zathura"
    "dunst"
    "pulseaudio"
    "tmux"
  ];
  collections = {
    coyote = [ ];
  };
in
{
  imports = [ transposeModule ];

  perSystem =
    { library, legacyDotfiles, ... }:
    let
      ps = lib.attrsets.genAttrs packagesWithSources (
        name: library.storeSource { source = lib.path.append ../src name; }
      );
      cs = builtins.mapAttrs (
        name: c:
        library.mergePackages {
          inherit name;
          packages = lib.attrsets.genAttrs c (name: legacyDotfiles.${name});
        }
      ) collections;
    in
    {
      legacyDotfiles = ps // cs;
    };
  flake.modules.nixos = builtins.mapAttrs (
    name: c:
    moduleWithSystem (
      { packages }:
      {
        users.users.${username}.packages = builtins.map (name: packages.${name}) c;
      }
    )
  ) collections;
}
