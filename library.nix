args@{ system, nixpkgs, ... }:
let
  nixpkgs = import args.nixpkgs {
    inherit system;
    # TODO  This was from old dotfiles; how to handle this config now?
    # config = {
    #   pulseaudio = true;
    #   allowUnfreePredicate = p:
    #     builtins.elem (this.get-name-substring p) [
    #       "discord"
    #       "spotify"
    #       "spotify-unwrapped"
    #       "vscode"
    #       "xflux"
    #       "zoom"
    #       "slack"
    #       "minecraft-launcher"
    #     ];
    # };
  };
  nixpkgs-lib = nixpkgs.lib;

  inherit (nixpkgs-lib) evalModules mkOption types;
  inherit (nixpkgs-lib.attrsets) getAttrs;
  inherit (nixpkgs) buildEnv;
  pathAppend = nixpkgs-lib.path.append;

  this = {

    mergePackages =
      {
        name,
        packages,
        args ? { },
      }:
      buildEnv (
        {
          inherit name;
          paths = builtins.attrValues packages;
          # TODO Is this the right place to do this?
          extraOutputsToInstall = [
            "man"
            "doc"
          ];
        }
        // args
      );

    # TODO `nix flake show` complains that this does not produce a derivation,
    # although `nix flake build`ing works fine.
    storeSource =
      {
        # Absolute path to the source, must not be a store path.
        source,
        # List of path strings to exclude, relative to source.
        excludes ? [
          "README.md"
          "default.nix"
        ],
      }:
      assert builtins.typeOf source == "path";
      let
        name = baseNameOf source;
        excludes' = map (p: pathAppend source p) excludes;
        filter = path: type: !builtins.elem (/. + path) excludes';
      in
      builtins.filterSource filter source;

    storeLegacyDotfiles = name: this.storeSource { source = pathAppend ./src name; };

    call = f: arg: f (this.getAttrs (builtins.attrNames (builtins.functionArgs f)) arg);

    calls = f: args: builtins.foldl' this.call f args;

    storeSymlink =
      name: source: destination:
      this.storeSymlinks {
        inherit name;
        mapping = [ { inherit source destination; } ];
      };

    storeSymlinks =
      { name, mapping }:
      let
        symlink-command =
          { source, destination }:
          ''
            destination="$out"${this.escape-shell-arg destination}
            mkdir -p "$(dirname "$destination")"
            ln -s ${this.escape-shell-arg source} "$destination"
          '';
        commands = map symlink-command mapping;
      in
      this.run-command-local name { } ''
        ${this.concat-strings commands}
      '';

    evalBrumalModules =
      let
        baseModule =
          top@{ packages, library, ... }:
          { system, config, ... }:
          {
            options = {
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
              users = mkOption {
                type = types.attrsOf types.attrsOf;
                description = ''
                  Users in this config.
                  TODO Tie to nixos users submodule.
                '';
                default = { };
              };
              legacyDotfiles = mkOption {
                types = types.types.lazyAttrsOf types.packages;
                description = ''
                  A shim to continue using my old-style dotfiles whilst I slowly migrate to pure nixos.
                '';
                default = { };
              };
              nixos = mkOption {
                types = types.types.lazyAttrsOf types.deferredModule;
                description = ''
                  Nixos modules.
                  TODO Enforce module class.
                '';
                default = { };
              };
            };
            config = {
              # TODO Should I alias better?
              _module.args.system = config.system;
              _module.args.packages = top.packages.${system};
              _module.args.library = top.library.${system};
            };
          };
      in
      { packages, library }:
      modules:
      evalModules {
        modules = [
          (baseModule { inherit packages library; })
        ] ++ modules;
      };
  };
in
this
