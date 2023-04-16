{
  lib
, nixpkgs
}:

with {
  inherit (lib)
  add_deps
  by_name
  get
  ;
};
let
  dotfiles_path = ./dotfiles;
  mk = lib.curry "name" lib.make_env;
  mk_with_src = lib.curry "name"
    (spec@{ name, ... }:
    lib.make_env ({
      inherit name;
      deps = [ (dotfiles_path + "/${name}") ];
    } // spec));
  mk_src = name: mk_with_src name {};
  add_pkg = env: add_deps [ (get env.name nixpkgs) ] env;
  mk_coll = name: deps: mk name { inherit deps; };
in
rec {
  srcs = by_name (map mk_src (lib.list_dir dotfiles_path));

  just_srcs = with srcs; by_name [
    default
    dunst
    i3wm
    pulseaudio
    x
  ];

  with_pkgs = with srcs; by_name (map add_pkg [
    curl
    git
    qutebrowser
    rofi
    tmux
    xflux
    zathura
    zsh
  ]);

  packages =
    just_srcs
    // with_pkgs
    // by_name [
      (add_deps [ nixpkgs.vimHugeX ] srcs.vim)

      (mk_coll "gui_env" [
        packages.xflux
        packages.zathura
      ])

      (mk_coll "wm_env" [
        packages.gui_env
        packages.i3wm
        packages.dunst
      ])
  ];
}
