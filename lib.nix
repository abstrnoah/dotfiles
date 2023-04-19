# TODO move to nixphile repository
# TODO trivial builder like for nixphile
{
  nixpkgs ? null
}:

rec {

  is_drv = x: (x.type or null) == "derivation";

  fold = builtins.foldl';

  get = builtins.getAttr;

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
  by_name = list_to_set "name";

  gen_set = f: fold (a: h: a // { "${h}" = f h; }) {};
  for_all = l: f: gen_set f l;

  # TODO a good idea but if i'm going to use this i need to support compsing
  #      things like composing nixphile_hook_pre etc.
  #      also, nixpkgs already has its override mechanism so
  # make_amendable =
  #   f: s@{ ... }:
  #   (f s) // { __constructor = make_amendable f; __preimage = s; };
  # amend =
  #   amender: # new: old: final
  #   image@{ __constructor, __preimage, ... }:
  #   new:
  #   __constructor (amender new __preimage);
  # amend_over = amend (new: old: old // new);
  # amend_under = amend (new: old: new // old);
  # amend_add =
  #   key:
  #   amend (new: old: override key ((builtins.getAttr key old) ++ new) old);
  # amend_name = name: image: amend_over image { inherit name; };
  # add_deps = amend_add "deps";

  make_env =
    {
      name ? "env"
    , deps
    , paths ? [ "/" ]
    , ...
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
    };

  bundle = name: deps: make_env { inherit name deps; };

  list_dir = path: builtins.attrNames (builtins.readDir path);

  store_file =
    source: target:
    nixpkgs.runCommand (baseNameOf source) { inherit source target; } ''
        dest=$out${nixpkgs.lib.escapeShellArg target}
        mkdir -p "$(dirname "$dest")"
        cp -T "$source" "$dest"
      '';

  store_text =
    source: target:
    nixpkgs.concatTextFile {
      name = baseNameOf target;
      files = [ source ];
      executable = false;
      destination = target;
    };

  store_script =
    source: target:
    nixpkgs.concatTextFile {
      name = baseNameOf target;
      files = [ source ];
      executable = true;
      destination = target;
    };

  # NOTE: Returns a _path_, not a derivation.
  make_source =
    {
      source # NOTE: should NOT be a store path
    , excludes ? []
    , ...
    }:
    # needed so that equality testing works
    assert builtins.all (p: builtins.typeOf p == "path") excludes;
    let
      name = baseNameOf source;
      filter = path: type: ! builtins.elem (/. + path) excludes;
    in
    builtins.filterSource filter source;

}
