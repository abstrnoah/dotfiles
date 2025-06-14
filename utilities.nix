{ library, nixpkgs }:
rec {
  inherit (nixpkgs)
    buildEnv
    runCommandLOcal
    writeTextFile
    writeShellApplication
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
    name: source: destination:
    storeSymlinks {
      inherit name;
      mapping = [ { inherit source destination; } ];
    };

  storeSymlinks =
    { name, mapping }:
    let
      symlinkCommand =
        { source, destination }:
        ''
          destination="$out"${library.escapeShellArg destination}
          mkdir -p "$(dirname "$destination")"
          ln -s ${library.escapeShellArg source} "$destination"
        '';
      commands = map symlinkCommand mapping;
    in
    runCommandLocal name { } ''
      ${library.concatStrings commands}
    '';

}
