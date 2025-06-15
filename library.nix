# TODO Maybe come up with a more flake-parts way of library.
{ nixpkgs-lib }:
let

  library = rec {

    inherit (nixpkgs-lib)
      evalModules
      mkOption
      types
      mkIf
      mkMerge
      mapAttrs
      mapAttrsToList
      filterAttrs
      nixosSystem
      ;
    inherit (nixpkgs-lib.attrsets)
      getAttrs
      attrValues
      ;
    inherit (nixpkgs-lib.strings)
      concatStrings
      escapeShellArg
      ;
    pathAppend = nixpkgs-lib.path.append;

    call = f: arg: f (getAttrs (builtins.attrNames (builtins.functionArgs f)) arg);

    calls = f: args: builtins.foldl' call f args;

    mkCases =
      value: cases:
      let
        f = case: branch: mkIf (value == case) branch;
        ifs = mapAttrsToList f cases;
        always = cases."*" or { };
        merge = mkMerge (ifs ++ [ always ]);
      in
      merge;

    evalBrumalModule =
      { modules }:
      let
        base.config._module.args.library = library;
        e = nixosSystem {
          modules = [ base ] ++ modules;
        };
      in
      e.config;

  };

in
library
