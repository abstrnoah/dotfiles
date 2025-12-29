top@{
  withSystem,
  inputs,
  library,
  config,
  ...
}:
let
  inherit (library)
    mkOption
    types
    getName
    overlayType
    mkForce
    ;
  cfg = config.brumal.nixpkgs;
in
{
  imports = [
    # TODO Move most overlays upstream
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  options.brumal.nixpkgs = {
    allowUnfree = mkOption { type = types.listOf types.str; };
    overlays = mkOption {
      default = [ ];
      type = types.listOf overlayType;
    };
  };

  config = {
    flake.nixosModules.brumal =
      { config, ... }:
      {
        # TODO: This pattern is documented at
        #       https://flake.parts/system.html?highlight=nixpkgs#configuring-nixpkgs-for-nixos
        #       However I am getting infinite recursion caused by the call to hostPlatform below.
        # imports = [
        #   inputs.nixpkgs.nixosModules.readOnlyPkgs
        # ];
        # NOTE: This is the unique origin of nixos-level `pkgs`.
        #       In particular this overrides whatever pkgs provided nixosSystem.
        nixpkgs.pkgs = mkForce (withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs));
      };

    perSystem =
      { system, ... }:
      {
        # NOTE: This is the unique origin of flake-level `pkgs`.
        #       Which in turn should be passed read-only to nixos.
        _module.args.pkgs = mkForce (
          import inputs.nixpkgs {
            inherit system;
            inherit (cfg) overlays;
            config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) cfg.allowUnfree;
          }
        );
      };

    # TODO: This still feels somewhat inelegant.
    #       easyOverlays get put into the flake's top-level flake.overlays.default,
    #       yet manual overlays get put into brumal.nixpkgs.overlays directly.
    #       Should all overlays go into the top-level flake.overlays?
    brumal.nixpkgs.overlays = [ config.flake.overlays.default ];
  };
}

# NOTE: nixpkgs-lib and pkgs may diverge. We don't care because nixpkgs-lib is inert.
