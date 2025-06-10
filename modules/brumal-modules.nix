top@{ config, lib, ... }:
let
  evalBrumalModules =
    let
      inherit (lib)
        mkOption
        types
        evalModules
        mkAfter
        mapAttrs
        genAttrs
        mkIf
        ;
      brumalOpts = {
        hostname = mkOption {
          type = types.str;
          description = ''
            A machine hostname.
            A module defines this option to communicate that it is describing a machine.
          '';
        };
        system = mkOption {
          type = types.enum [
            "aarch64-linux"
            "x86_64-linux"
          ];
          description = ''
            A system string.
            A module defines this to communicate that it is only compatible with such system.
            It determines which `packages` and `library` appear as module arguments and is aliased to `system` module argument.
            TODO Maybe tie type into github:nix-systems.
          '';
        };
        distro = mkOption {
          type = types.enum [
            "debian"
            "nixos"
          ];
          description = ''
            A distribution string.
          '';
        };
        owner = mkOption {
          type = types.attrsOf types.anything;
          description = ''
            The user who ownes this config.
            TODO Improve typing.
          '';
        };
        # TODO For simplicity, at this time, we just handle the single-user situation.
        # users = mkOption {
        #   type = types.attrsOf types.attrsOf;
        #   description = ''
        #     Users in this config.
        #     TODO Tie to nixos users submodule.
        #   '';
        #   default = { };
        # };
        legacyDotfiles = mkOption {
          type = types.lazyAttrsOf types.package;
          description = ''
            A shim to continue using my old-style dotfiles whilst I slowly migrate to pure nixos.
          '';
          default = { };
        };
        systemPackages = mkOption {
          type = types.lazyAttrsOf types.package;
          description = ''
            Distro-agnostic option for system packages, will be passed to appropriate distro-level config automatically if possible.
            On non-NixOS machines, this just gets merged with userPackages (TODO).
          '';
          default = { };
        };
        userPackages = mkOption {
          type = types.lazyAttrsOf types.package;
          description = ''
            Distro-agnostic option for user packages, will be passed to appropriate distro-level config automatically.
          '';
          default = { };
        };
        nixos = mkOption {
          type = types.deferredModule;
          description = ''
            Nixos module.
            TODO Enforce module class.
          '';
          default = { };
        };
      };
      baseModule =
        {
          system,
          config,
          options,
          ...
        }:
        {
          _file = "baseModule";
          options = brumalOpts;
          config = {
            _module.args.system = config.system;
            _module.args.packages = top.config.flake.packages.${system};
            _module.args.library = top.config.flake.library.${system};
            _module.args.pkgs = top.config.flake.nixpkgs.${system};
          };
        };

      # TODO This was copy-pasted from library.nix for bootstrapping reasons.
      # Key `"*"` gets merged in all cases.
      mkCases =
        value: cases:
        let
          f = case: branch: lib.mkIf (value == case) branch;
          ifs = lib.mapAttrsToList f cases;
          always = cases."*" or { };
          merge = lib.mkMerge (ifs ++ [ always ]);
        in
        merge;

    in
    modules:
    evalModules {
      specialArgs = { inherit mkCases; };
      modules = [ baseModule ] ++ modules;
      class = "brumal";
    };
in
{
  _module.args.evalBrumalModule = module: (evalBrumalModules [ module ]).config;
}
