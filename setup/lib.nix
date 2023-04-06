{ nixpkgs }:

{
  make_module =
    name:
    config@{
      prefix_substs ? { "dot-files" = ".file"; }
    , exclude_file ? ""
    }:
    deps:
    nixpkgs.buildEnv {
      inherit name;
      paths = deps;
      ignoreCollisions = false; # TODO check if these two give desired behaviour
      checkCollisionContents = true;
    }
  ;

  spec_to_module =
    name:
    spec@{
      config ? {}
    , deps # a list of paths or other specs
    }:
    let
      dive = dep: if (isPath dep) then [ dep ] else (merge dep.deps);
      merge = deps: concatMap dive deps;
    in
    make_module name config (merge deps)
  ;

  specs_to_modules = specs: map spec_to_module specs;
}
