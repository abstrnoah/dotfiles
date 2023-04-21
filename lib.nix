# TODO move to nixphile repository
# TODO trivial builder like for nixphile
{
  nixpkgs ? null
, ...
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

  # This is very similar to nixpkgs' makeOverridable. One important difference
  # is that it is easier to get the original arguments with this implementation,
  # TODO what happens when you make_amendable an already-amentable function?

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

  make_env =
    {
      name ? "env"
    , deps
    , paths ? [ "/" ]
    , ...
    }:
    assert nixpkgs != null;
    let
      # TODO FIXME awful terrible doesn't work when two deps have same common dep
      nixphile_hook_pre =
        bundle_scripts
          (map (get "nixphile_hook_pre")
            (builtins.filter (x: x ? nixphile_hook_pre) deps));
    in
    (nixpkgs.buildEnv {
      inherit name;
      paths = deps;
      # TODO buildEnv requires pathsToLink to be directories; I'd like it to
      # support regular files eventually.
      pathsToLink = paths;
      ignoreCollisions = false; # TODO check if these two give desired behaviour
      checkCollisionContents = true;
      extraOutputsToInstall = [ "man" "doc" ];
    })
    // { inherit nixphile_hook_pre; };

  bundle = name: deps: make_env { inherit name deps; };

  list_dir = path: builtins.attrNames (builtins.readDir path);

  store_file =
    source: target:
    nixpkgs.runCommand (baseNameOf source) {
      source = "${source}"; # copy source to nix store
      inherit target;
    }
    ''
      dest=$out${nixpkgs.lib.escapeShellArg target}
      mkdir -p "$(dirname "$dest")"
      ln -s "$source" "$dest"
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

  # Make nixpkgs' writeShellApplication amendable.
  # Use make_amendable instead of nixpkgs.makeOverridable because my
  # implementation easily exposes original args.
  write_script = make_amendable nixpkgs.writeShellApplication;

  cat_scripts =
    a: b:
    if a == null then
      b
    else if b == null then
      a
    else
      amend (new: old: old // {
        text = old.text + new.text;
        runtimeInputs = old.runtimeInputs or [] ++ new.runtimeInputs or [];
      }) a b.__preimage;

  bundle_scripts = scripts: fold cat_scripts null scripts;

  # TODO FIXME this whole nixphile hook riffraff.
  # - Handle circular dependencies.
  # - When bundling packages with common hooks, deduplicate.
  # - Handle ordering?
  make_nixphile_hook_pre =
    text:
    {
      nixphile_hook_pre =
        write_script { name = "nixphile_hook_pre"; inherit text; };
    };

  # TODO helper that easily creates a flake from static assets like in wallpapers
}
