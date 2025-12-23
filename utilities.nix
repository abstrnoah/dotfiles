{ library, nixpkgs }:
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

}
