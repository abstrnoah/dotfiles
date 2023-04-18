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

  make_amendable =
    f: s@{ ... }:
    (f s) // { __constructor = make_amendable f; __preimage = s; };

  amend =
    amender: # new: old: final
    image@{ __constructor, __preimage, ... }:
    new:
    __constructor (amender new __preimage);

  amend_over = amend (new: old: old // new);
  amend_under = amend (new: old: new // old);
  amend_add =
    key:
    amend (new: old: override key ((builtins.getAttr key old) ++ new) old);
  amend_name = name: image: amend_over image { inherit name; };

  make_env = make_amendable
    ({
      name ? "env"
    , deps
    , prefix_substs ? null # { "dot-files" = ".file"; } # TODO not implemented
    , excludes ? null # TODO not implemented
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
    });

  add_deps = amend_add "deps";

  list_dir = path: builtins.attrNames (builtins.readDir path);

  store_file =
    source: target:
    nixpkgs.runCommand (baseNameOf source) { inherit source target; } ''
        dest=$out${nixpkgs.lib.escapeShellArg target}
        mkdir -p "$(dirname "$dest")"
        cp "$source" "$dest"
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

}
