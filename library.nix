{ nixpkgs-lib }:
let
  library = rec {

    inherit (nixpkgs-lib)
      evalModules
      mkOption
      types
      mkIf
      mkMerge
      mkDefault
      mapAttrs
      mapAttrs'
      nameValuePair
      mapAttrsToList
      filterAttrs
      nixosSystem
      getName
      pathExists
      concatStringsSep
      collect
      isString
      genAttrs
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
    attrsToGitINI = nixpkgs-lib.generators.toGitINI;

    call = f: arg: f (getAttrs (builtins.attrNames (builtins.functionArgs f)) arg);

    calls = f: args: builtins.foldl' call f args;

    mkCases =
      value: cases:
      let
        f = case: branch: mkIf (value == case) branch;
        ifs = mapAttrsToList f cases;
        always = mkIf (cases ? "*") (cases."*" or { });
        merge = mkMerge (ifs ++ [ always ]);
      in
      merge;

    evalBrumalModule =
      { modules }:
      nixosSystem {
        inherit modules;
        specialArgs = { inherit library; };
      };

  };
in
library
