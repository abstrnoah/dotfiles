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

  make_env =
    {
      envs
    , prefix_substs ? null # { "dot-files" = ".file"; } # TODO not implemented
    , excludes ? null # TODO not implemented
    , paths ? [ "/" ]
    }:
    nixpkgs.buildEnv {
      # I don't want to deal with internalising attribute names so instead am
      # giving everything env the generic name "env". Personally the name field
      # of outputs doesn't matter to me anyway.
      name = "env";
      paths = envs;
      # TODO buildEnv requires pathsToLink to be directories; I'd like it to
      # support regular files eventually.
      pathsToLink = paths;
      ignoreCollisions = false; # TODO check if these two give desired behaviour
      checkCollisionContents = true;
    };

  isDerivation = x: if (x ? type) then (x.type == "derivation") else false;

  # TODO should really check whether relative path (then must exist) or store path
  isEnv = x: with builtins; isPath x || isString x || isDerivation x;

  spec_to_env =
    spec@{ envs, ... }:
    let
      dive = e: if (isEnv e) then e else (spec_to_env e);
    in
    make_env (spec // { envs = map dive spec.envs; });

  specs_to_envs = specs: builtins.mapAttrs (n: s: spec_to_env s) specs;

  provided_envs =
    specs_to_envs rec {
      stow_bin = { envs = [ nixpkgs.stow ]; paths = [ "/bin" ]; };
      boot_reqs = { envs = [ stow_bin ]; };
    };

  envs = specs_to_envs (import ./envs.nix { inherit nixpkgs; });
}
