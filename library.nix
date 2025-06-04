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

    storeLegacyDotfiles name = this.storeSource { source = pathAppend ./src name; };

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
  };
in
this
