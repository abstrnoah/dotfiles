{
  lib ? import ./lib.nix { nixpkgs = import <nixpkgs> {}; }
}:

let
  nixpkgs = lib.nixpkgs;
  mk = (lib.curry "name" lib.make_env);
  mkdot = lib.make_dotfiles ./dotfiles null;
in
rec {
  envs = lib.list_to_set "name" [
    (mk "install" {
      deps = with nixpkgs; [
        coreutils
        curl
        git
        glibcLocales
        xstow
      ];
    })
    (mkdot "test1" { deps = [ envs.install ]; })
    (mkdot "test2" { deps = [ envs.test1 ]; })
    (mkdot "test3" { deps = [ envs.test2 ]; })
  ] // {
    default = envs.install;
  };
}
