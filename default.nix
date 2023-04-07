let
  nixpkgs_commit = "36adaa6aaa6b03e59102df0c1b12cdc3f23fd112";
  nixpkgs_uri =
    "https://github.com/NixOS/nixpkgs/archive/${nixpkgs_commit}.tar.gz";
  nixpkgs_expr = import (fetchTarball nixpkgs_uri) {};
in

{
  nixpkgs ? nixpkgs_expr
}:

rec {
  inherit nixpkgs;

  is_drv = x: x.type or null == "derivation";

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

  make_env =
    {
      name ? "env"
    , envs
    , prefix_substs ? null # { "dot-files" = ".file"; } # TODO not implemented
    , excludes ? null # TODO not implemented
    , paths ? [ "/" ]
    }:
    nixpkgs.buildEnv {
      inherit name;
      paths = envs;
      # TODO buildEnv requires pathsToLink to be directories; I'd like it to
      # support regular files eventually.
      pathsToLink = paths;
      ignoreCollisions = false; # TODO check if these two give desired behaviour
      checkCollisionContents = true;
    } // { _type = "env"; };

  make_dotfiles =
    name: spec@{ ... }:
    make_env (spec // { inherit name; envs = [ (./dotfiles + "/${name}") ]; });

  envs = user_envs // provided_envs;

  provided_envs = list_to_set "name" [
    (make_env { name = "stow_bin";
                envs = [ nixpkgs.stow ]; paths = [ "/bin" ]; })
    (make_env { name = "boot_reqs"; envs = [ envs.stow_bin ]; })
  ];

  user_envs = list_to_set "name" [
    (make_dotfiles "root" {})
  ];
}
