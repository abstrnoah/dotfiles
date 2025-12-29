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
      filter
      filterAttrs
      nixosSystem
      getName
      pathExists
      concatStringsSep
      concatMapAttrsStringSep
      collect
      isString
      genAttrs
      readFile
      replaceStrings
      mkDerivedConfig
      ;
    inherit (nixpkgs-lib.attrsets)
      getAttrs
      getAttr
      attrNames
      attrValues
      ;
    inherit (nixpkgs-lib.strings)
      concatStrings
      escapeShellArg
      escapeXML
      ;
    pathAppend = nixpkgs-lib.path.append;
    attrsToINI = nixpkgs-lib.generators.toINI;
    attrsToGitINI = nixpkgs-lib.generators.toGitINI;
    attrsToYAML = nixpkgs-lib.generators.toYAML { };
    attrsToJSON = nixpkgs-lib.generators.toJSON { };

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

    hexColourType = types.strMatching "#[[:xdigit:]]{6}";
    nameType = types.strMatching "[a-zA-Z_-][0-9a-zA-Z_-]*";

  };
in
library
