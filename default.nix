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
  add_pkg = env: add_deps env [ (get env.name nixpkgs) ];
  mk_coll = name: deps: mk name { inherit deps; };
in
rec {

  srcs = by_name (map mk_src (lib.list_dir dotfiles_path));

  packages = by_name [

    # originally from corePackagePaths

    (add_deps nixpkgs.bat (with nixpkgs.bat-extras; [
      batdiff
      batman
      batwatch
    ]))

    (add_pkg srcs.curl)

    nixpkgs.dig
    nixpkgs.dnstracer
    nixpkgs.fd
    nixpkgs.fzf

    (add_pkg srcs.git)

    nixpkgs.glibcLocales
    nixpkgs.htop
    nixpkgs.jq
    nixpkgs.netcat-openbsd
    nixpkgs.nettools
    nixpkgs.nodejs
    nixpkgs.pandoc
    nixpkgs.pdfgrep
    nixpkgs.pdftk
    nixpkgs.pfetch
    nixpkgs.ranger
    nixpkgs.silver-searcher
    nixpkgs.sl
    nixpkgs.tectonic
    nixpkgs.textql
    nixpkgs.time

    (add_deps srcs.tmux [ nixpkgs.tmux nixpkgs.tmuxinator ])

    nixpkgs.toilet
    nixpkgs.tree
    nixpkgs.tuptime
    nixpkgs.universal-ctags

    (add_deps nixpkgs.zip [ nixpkgs.unzip ])

    (add_deps srcs.vim [ nixpkgs.vimHugeX ])

    nixpkgs.visidata

    # originally from clientPackages

    nixpkgs.black
    nixpkgs.bup
    nixpkgs.clang
    nixpkgs.clojure
    nixpkgs.coq
    nixpkgs.cowsay
    nixpkgs.delta
    nixpkgs.djvu2pdf
    nixpkgs.dmidecode
    nixpkgs.exiftool
    nixpkgs.gcal
    nixpkgs.imagemagick
    nixpkgs.img2pdf
    nixpkgs.jdk
    nixpkgs.maven

    (amend_name "insect" nixpkgs.nodePackages.insect)

    (add_deps nixpkgs.ocaml [
      nixpkgs.ocamlformat
      nixpkgs.ocamlPackages.utop
    ])

    nixpkgs.php
    nixpkgs.python3
    nixpkgs.rlwrap
    nixpkgs.spotify-cli-linux
    nixpkgs.sqlfluff
    nixpkgs.stow
    nixpkgs.texlive.combined.scheme-small
    nixpkgs.weechat
    nixpkgs.wego
    nixpkgs.yj
    nixpkgs.yq-go

    # originally from clientPackagesGui

    nixpkgs.libnotify
    nixpkgs.mpv
    nixpkgs.okular
    (amend_name "grip" nixpkgs.python310Packages.grip)

    (add_pkg srcs.qutebrowser)

    (add_pkg srcs.rofi)

    nixpkgs.signal-desktop
    nixpkgs.spotify
    nixpkgs.wmctrl
    nixpkgs.xclip

    (add_pkg srcs.xflux)

    nixpkgs.xournalpp

    (add_pkg srcs.zathura)

    # originally from nix-on-droid

    nixpkgs.diffutils
    nixpkgs.findutils
    nixpkgs.getconf
    nixpkgs.gnugrep
    nixpkgs.gnused
    nixpkgs.hostname
    nixpkgs.man
    nixpkgs.openssh
    nixpkgs.procps
    nixpkgs.utillinux

    (add_pkg srcs.zsh)


    (add_deps srcs.x [
      nixpkgs.xrandr-invert-colors
      nixpkgs.xorg.xbacklight
    ])

    srcs.i3wm
    (add_pkg srcs.dunst)


    # collections

    (mk_coll "nix-on-droid" (with packages; [
      core_env
      openssh
      procps
      utillinux
    ]))

    (mk_coll "core_env" (with packages; [
      diffutils
      findutils
      getconf
      gnugrep
      gnused
      hostname
      man
      bat
      curl
      dig
      dnstracer
      fd
      fzf
      git
      glibcLocales
      htop
      jq
      netcat-openbsd
      nettools
      nodejs
      pandoc
      pdfgrep
      pdftk
      pfetch
      ranger
      silver-searcher
      sl
      tectonic
      textql
      time
      tmux
      toilet
      tree
      tuptime
      universal-ctags
      zip
      vim
      visidata
      rlwrap
    ]))

    (mk_coll "default" (with packages; [
      core_env
      black
      bup
      clang
      clojure
      coq
      cowsay
      exiftool
      gcal
      imagemagick
      img2pdf
      jdk
      maven
      insect
      ocaml
      python3
      stow
    ]))

    (mk_coll "gui_env" (with packages; [
      default
      libnotify
      mpv
      grip
      qutebrowser
      signal-desktop
      spotify
      xclip
      xournalpp
      zathura
    ]))

    (mk_coll "wm_env" (with packages; [
      gui_env
      rofi
      wmctrl
      xflux
      x
      i3wm
      dunst
    ]))

  ];

}
