# NOTICE: I deprecated this in favour of just configuring nixpkgs within the module system as intended. This has the downside of my configured nixpkgs is not accessible outside of the module system but that's a problem for older me.

top@{
  library,
  inputs,
  flake-parts-lib,
  config,
  ...
}:
let
  perSystemOutputModule = flake-parts-lib.mkTransposedPerSystemModule {
    name = "nixpkgs";
    option = library.mkOption {
      type = library.types.pkgs;
    };
    file = ./nixpkgs.nix;
  };
  # TODO Ideally this is set via the module system, but for sake of sanity we want to keep all nixpkgs config here until we better understand how nixpkgs is passed around.
  nixpkgs-config = {
    pulseaudio = true;
    allowUnfreePredicate =
      p:
      builtins.elem (library.getName p) [
        "discord"
        "spotify"
        "spotify-unwrapped"
        "vscode"
        "xflux"
        "zoom"
        "slack"
        "minecraft-launcher"
      ];
  };
in
{

  imports = [ perSystemOutputModule ];

  config.perSystem =
    { system, config, ... }:
    {
      # SOURCE OF TRUTH
      # This is the one true nixpkgs within this flake (hopefully).
      # TODO Instead of this, try intercepting nixosSystem's `pkgs`.
      nixpkgs = import inputs.nixpkgs {
        inherit system;
        config = nixpkgs-config;
      };

      # Flake parts perSystem gets pkgs from inputs by default, but we override here.
      _module.args.pkgs = config.nixpkgs;
    };

  # TODO Reconsider this, remember "Use this option with care" :clown:
  config.flake.nixosModules.base =
    { system, ... }:
    {
      nixpkgs.pkgs = top.config.flake.nixpkgs.${system};
    };

}
