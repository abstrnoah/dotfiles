top@{
  lib,
  inputs,
  flake-parts-lib,
  config,
  ...
}:
let
  perSystemM = flake-parts-lib.mkTransposedPerSystemModule {
    name = "nixpkgs";
    option = lib.mkOption {
      type = lib.types.pkgs;
    };
    file = ./nixpkgs.nix;
  };
in
{
  imports = [ perSystemM ];

  # TODO Ideally, this config is moved into brumal modules for more fine-grained control. However, since so much is down stream of nixpkgs, it's too much of a pain to handle different versions of nixpkgs at this time.
  options.nixpkgs-config = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
  };

  config.perSystem =
    { system, config, ... }:
    {
      # SOURCE OF TRUTH
      # This is the one true nixpkgs within this flake.
      nixpkgs = import inputs.nixpkgs {
        inherit system;
        config = top.config.nixpkgs-config;
      };

      # Flake parts perSystem gets pkgs from inputs by default, but we override here.
      _module.args.pkgs = config.nixpkgs;
    };

  config.nixpkgs-config = {
    pulseaudio = true;
    allowUnfreePredicate =
      p:
      builtins.elem (lib.getName p) [
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

}
