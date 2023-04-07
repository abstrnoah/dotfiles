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

  is_drv = x: if (x ? type) then (x.type == "derivation") else false;

  # TODO should really check whether relative path (then must exist) or store path
  is_env = x: with builtins; isPath x || isString x || is_drv x;

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
    };

  spec_to_env =
    spec@{ envs, ... }:
    let
      dive = e: if (is_env e) then e else (spec_to_env e);
    in
    make_env (spec // { envs = map dive spec.envs; });

  specs_to_envs = specs: builtins.mapAttrs (n: s: spec_to_env s) specs;

  spec_dotfiles =
    name: spec@{ ... }:
    spec // { inherit name; envs = [ (./dotfiles + "/${name}") ]; };

  make_dotfiles = n: s: make_env (spec_dotfiles n s);

  name_sets =
    sets:
    let
      m =
        name: s:
        assert s ? name -> s.name == name;
        s // { inherit name; };
      in
      builtins.mapAttrs m sets;

  provided_envs =
    let
      _ = name_sets _';
      _' = rec {
        stow_bin = { envs = [ nixpkgs.stow ]; paths = [ "/bin" ]; };
        boot_reqs = { envs = [ _.stow_bin ]; };
      };
    in
    specs_to_envs _;

  envs =
    let
      _ = name_sets _';
      _' = rec {
        root = spec_dotfiles "root" {};
      };
    in
    specs_to_envs _;
}
