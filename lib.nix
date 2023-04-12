{
  nixpkgs ? null
}:

rec {

  inherit nixpkgs;

  is_drv = x: (x.type or null) == "derivation";

  is_env = x: is_drv x && x._type or null == "env";

  fold = builtins.foldl';

  override = key: value: set@{ ... }: set // { ${key} = value; };

  intern =
    key: value: set@{ ... }:
    assert builtins.hasAttr key set -> (builtins.getAttr key set) == value;
    override key value set;

  curry =
    key:
    f: # function of the form (set@{ key, ... }: ...)
    value: set@{ ... }:
    f (intern key value set);

  extern = key: set@{ ... }: { "${set.${key}}" = set; };

  list_to_set = key: fold (s: x: s // (extern key x)) {};

  gen_set = f: fold (a: h: a // { "${h}" = f h; }) {};

  make_env =
    {
      name ? "env"
    , deps
    , prefix_substs ? null # { "dot-files" = ".file"; } # TODO not implemented
    , excludes ? null # TODO not implemented
    , paths ? [ "/" ]
    }:
    assert nixpkgs != null;
    nixpkgs.buildEnv {
      inherit name;
      paths = deps;
      # TODO buildEnv requires pathsToLink to be directories; I'd like it to
      # support regular files eventually.
      pathsToLink = paths;
      ignoreCollisions = false; # TODO check if these two give desired behaviour
      checkCollisionContents = true;
      extraOutputsToInstall = [ "man" "doc" ];
    } // { _type = "env"; };

  make_dotfiles =
    dotfiles: # path to source environments
    base_env: # base env to include in all results
    name: spec@{ ... }:
    let
      deps = [ (dotfiles + "/${name}") ]
             ++ (spec.deps or [])
             ++ (if base_env != null then [ base_env ] else []);
    in
    make_env (spec // { inherit name deps; });

}
