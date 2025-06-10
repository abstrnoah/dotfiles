args@{ system, nixpkgs, ... }:
let
  nixpkgs-lib = nixpkgs.lib;

  inherit (nixpkgs-lib) evalModules mkOption types;
  inherit (nixpkgs-lib.attrsets) getAttrs;
  inherit (nixpkgs-lib.strings) concatStrings escapeShellArg;
  inherit (nixpkgs) buildEnv runCommandLocal;
  pathAppend = nixpkgs-lib.path.append;

  this = {

    inherit (nixpkgs-lib) mapAttrsToList mkIf mkMerge;
    inherit (nixpkgs) writeTextFile writeShellApplication;

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
            destination="$out"${escapeShellArg destination}
            mkdir -p "$(dirname "$destination")"
            ln -s ${escapeShellArg source} "$destination"
          '';
        commands = map symlink-command mapping;
      in
      runCommandLocal name { } ''
        ${concatStrings commands}
      '';

  };

  # Key `"*"` gets merged in all cases.
  mkCases =
    value: cases:
    let
      f = case: branch: this.mkIf (value == case) branch;
      ifs = this.mapAttrsToList f cases;
      always = cases."*" or { };
      merge = this.mkMerge (ifs ++ [ always ]);
    in
    merge;

in
this
