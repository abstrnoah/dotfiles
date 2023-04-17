# TODO bundle pass, gpg, tomb? tomb,gpg provided natively
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

  packages = {

    # originally from corePackagePaths

    bat = (mk_coll "bat" [
      nixpkgs.bat
      nixpkgs.bat-extras.batdiff
      nixpkgs.bat-extras.batman
      nixpkgs.bat-extras.batwatch
    ]);

    curl = (add_pkg srcs.curl);

    inherit (nixpkgs)
    dig
    dnstracer
    fd
    fzf
    ;

    git = (add_pkg srcs.git);

    inherit (nixpkgs)
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
    ;

    tmux = (add_deps srcs.tmux [
      nixpkgs.tmux
      nixpkgs.tmuxinator
      packages.zsh # TODO avoid circular dependency?
      packages.fzf
      # TODO xclip?
      packages.gcal
    ]);

    inherit (nixpkgs)
    toilet
    tree
    tuptime
    universal-ctags
    ;

    zip = (mk_coll "zip" [ nixpkgs.zip nixpkgs.unzip ]);

    vim = add_deps srcs.vim [
      nixpkgs.vimHugeX
      packages.fzf
      packages.curl
    ];

    inherit (nixpkgs) visidata;

    # originally from clientPackages

    inherit (nixpkgs)
    black
    bup
    clang
    clojure
    coq
    cowsay
    delta
    djvu2pdf
    dmidecode
    exiftool
    gcal
    imagemagick
    img2pdf
    jdk
    maven
    ;

    inherit (nixpkgs.nodePackages) insect;

    ocaml = (mk_coll "ocaml" [
      nixpkgs.ocaml
      nixpkgs.ocamlformat
      nixpkgs.ocamlPackages.utop
    ]);

    inherit (nixpkgs)
    php
    python3
    rlwrap
    spotify-cli-linux
    sqlfluff
    stow
    weechat
    wego
    yj
    yq-go
    ;

    texlive-combined-small = nixpkgs.texlive.combined.scheme-small;

    # originally from clientPackagesGui

    inherit (nixpkgs)
    libnotify
    mpv
    okular
    ;

    inherit (nixpkgs.python310Packages) grip;

    qutebrowser = (add_pkg srcs.qutebrowser);

    # TODO handle environment issue
    rofi = (add_pkg srcs.rofi);

    inherit (nixpkgs)
    signal-desktop
    spotify
    wmctrl
    xclip
    ;

    xflux = add_deps (add_pkg srcs.xflux) [ packages.curl packages.jq ];

    inherit (nixpkgs) xournalpp;

    zathura = (add_pkg srcs.zathura);

    # originally from nix-on-droid

    inherit (nixpkgs)
    diffutils
    findutils
    getconf
    gnugrep
    gnused
    hostname
    man
    openssh
    procps
    utillinux
    ;

    zsh = add_deps (add_pkg srcs.zsh) (with packages; [
      bat
      fzf
      fd
    ]);


    # TODO currently xsession execs native i3; really this should depend on i3wm
    x = (add_deps srcs.x [
      nixpkgs.xrandr-invert-colors
      nixpkgs.xorg.xbacklight
    ]);

    # TODO
    # wallpapers = ;

    inherit (srcs)
    pass
    pulseaudio
    ;

    # TODO eventually have nix provide i3-gaps, i3lock, pulse, feh
    # TODO requires pactl, which is currently provided natively
    # TODO requires systemctl
    # TODO passmenu?
    i3wm = add_deps srcs.i3wm (with packages; [
      jq
      # wallpapers # TODO
      dunst
      rofi
      wmctrl
      spotify-cli-linux
      x
      xflux
      pass
    ]);

    dunst = (add_pkg srcs.dunst);


    # collections

    nix-on-droid = (mk_coll "nix-on-droid" (with packages; [
      core_env
      openssh
      procps
      utillinux
    ]));

    core_env = (mk_coll "core_env" (with packages; [
      # TODO nixphile
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
    ]));

    default = (mk_coll "default" (with packages; [
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
    ]));

    gui_env = (mk_coll "gui_env" (with packages; [
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
      pulseaudio
    ]));

    wm_env = (mk_coll "wm_env" (with packages; [
      gui_env
      rofi
      wmctrl
      xflux
      x
      i3wm
      dunst
    ]));

  };

}
