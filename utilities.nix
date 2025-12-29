{ library, nixpkgs }:
let
  inherit (library)
    replaceStrings
    mkOption
    types
    mkDefault
    mkIf
    mkDerivedConfig
    ;
in
rec {
  inherit (nixpkgs)
    buildEnv
    runCommandLocal
    writeText
    writeTextFile
    writeShellApplication
    writeShellScript
    concatScript
    ;

  mergePackages =
    {
      name,
      packages,
      args ? { },
    }:
    buildEnv (
      {
        inherit name;
        paths = library.attrValues packages;
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
      excludes' = map (p: library.pathAppend source p) excludes;
      filter = path: type: !builtins.elem (/. + path) excludes';
    in
    builtins.filterSource filter source;

  storeLegacyDotfiles = name: storeSource { source = library.pathAppend ./src name; };

  storeSymlink =
    name: source: target:
    storeSymlinks {
      inherit name;
      mapping = [ { inherit source target; } ];
    };

  storeSymlinks =
    {
      name,
      destination ? "/",
      mapping,
    }:
    let
      symlinkCommand =
        { source, target }:
        ''
          dest="$out/$destination/"${library.escapeShellArg target}
          mkdir -p "$(dirname "$dest")"
          ln -s ${library.escapeShellArg source} "$dest"
        '';
      commands = map symlinkCommand mapping;
    in
    runCommandLocal name { inherit destination; } ''
      ${library.concatStrings commands}
    '';

  fileType = types.submodule (
    {
      name,
      config,
      options,
      ...
    }:
    {
      options = {
        target = mkOption {
          description = "Relative path.";
          type = types.str;
        };
        source = mkOption { type = types.path; };
        text = mkOption {
          default = null;
          type = types.nullOr types.lines;
        };
      };
      config = {
        target = mkDefault name;
        source = mkIf (config.text != null) (
          let
            name' = replaceStrings [ "/" ] [ "-" ] name;
          in
          mkDerivedConfig options.text (writeText name')
        );
      };
    }
  );

  filesType = types.attrsOf fileType;

}
