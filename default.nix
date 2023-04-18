# TODO
# - xclip? non-x-reliant clipboard manager?
{
  lib
, nixpkgs
, system ? builtins.currentSystem # TODO maybe improve how we handle system
}:

with {
  inherit (lib)
  add_deps
  by_name
  get
  store_text
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

  packages = rec {

    inherit (nixpkgs)
    black
    bup
    clang
    coq
    cowsay
    diffutils
    dig
    dnstracer
    exiftool
    fd
    findutils
    fzf
    gcal
    getconf
    gnugrep
    gnused
    grip
    hostname
    htop
    i3status
    imagemagick
    img2pdf
    jdk
    jq
    libnotify
    man
    mpv
    netcat-openbsd
    nettools
    nodejs
    openssh
    pandoc
    pdfgrep
    pdftk
    pfetch
    procps
    ranger
    rlwrap
    signal-desktop
    silver-searcher
    sl
    spotify-cli-linux
    stow
    tectonic
    textql
    time
    tmuxinator
    toilet
    tree
    tuptime
    universal-ctags
    utillinux
    visidata
    wmctrl
    xclip
    xournalpp
    xrandr-invert-colors
    ;

    inherit (nixpkgs.nodePackages) insect;

    telegram = nixpkgs.tdesktop;

    xorg-xbacklight = nixpkgs.xorg.xbacklight;

    bat = mk_coll "bat" [
      nixpkgs.bat
      nixpkgs.bat-extras.batdiff
      nixpkgs.bat-extras.batman
      nixpkgs.bat-extras.batwatch
    ];

    curl = add_pkg srcs.curl;

    git = add_pkg srcs.git;

    # TODO probably better to achive this with substituteAll instead
    nix_env_exports =
      let
        locale_archive = "${nixpkgs.glibcLocales}/lib/locale/locale-archive";
      in
      nixpkgs.writeTextFile rec {
        name = "nix_env_exports";
        text = ''
          export ${nixpkgs.lib.toShellVar "LOCALE_ARCHIVE" locale_archive}
        '';
        destination = "/lib/${name}";
      };

    tmux = mk_coll "tmux" [
      fzf
      gcal
      nixpkgs.tmux
      srcs.tmux
      tmuxinator # TODO pull in projects from shh
      zsh # TODO rm this dep
    ];

    zip = mk_coll "zip" [ nixpkgs.zip nixpkgs.unzip ];

    vim-plug =
      store_text
      "${nixpkgs.vimPlugins.vim-plug}/plug.vim"
      "/home/me/.vim/autoload/plug.vim";

    # TODO mutable spellfile
    vim = mk_coll "vim" [
      curl
      fzf
      nixpkgs.vimHugeX
      srcs.vim
      vim-plug
    ];

    ocaml = mk_coll "ocaml" [
      nixpkgs.ocaml
      nixpkgs.ocamlformat
      nixpkgs.ocamlPackages.utop
    ];

    # TODO needs ~/.config/qutebrowser/.keep
    qutebrowser = add_pkg srcs.qutebrowser;

    rofi = add_pkg srcs.rofi;

    spotify = mk_coll "spotify" [ nixpkgs.spotify spotify-cli-linux ];

    xflux = mk_coll "xflux" [
      curl
      jq
      nixpkgs.xflux
      srcs.xflux
    ];

    zathura = add_pkg srcs.zathura;

    zsh = mk_coll "zsh" [
      bat
      fd
      fzf
      nix_env_exports
      nixpkgs.zsh
      srcs.zsh
    ];

    i3wm = nixpkgs.i3-gaps;

    xsession = nixpkgs.writeTextFile {
      name = "xsession";
      text = ''
        exec "${i3wm}/bin/i3"
      '';
      destination = "/home/me/.xsession";
    };

    wallpapers = mk_coll "wallpapers" [
      (lib.store_file
      ./share/wallpapers/solarized-disks.png
      "/home/me/.wallpaper")
      (lib.store_file
      ./share/wallpapers/solarized-stars.png
      "/home/me/.wallpaperlock")
    ];

    passmenu = srcs.pass;

    # TODO needs ~/.config/pulse/.keep
    dunst = add_pkg srcs.dunst;

    pulseaudio = add_pkg srcs.pulseaudio;

    nix-on-droid = mk_coll "nix-on-droid" [
      core_env
      openssh
      procps
      utillinux
    ];

    core_env = mk_coll "core_env" [
      srcs.core_env
      srcs.nix
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
      htop
      jq
      netcat-openbsd
      nettools
      nodejs
      pandoc
      pdfgrep
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
    ];

    default = mk_coll "default" [
      core_env
      black
      bup
      clang
      coq
      cowsay
      exiftool
      gcal
      imagemagick
      img2pdf
      insect
      ocaml
      # python3 # rming from default bc causes heavy initial build
      stow
      jdk
      pdftk
    ];

    gui_env = mk_coll "gui_env" [
      default
      grip
      libnotify
      mpv
      pulseaudio
      qutebrowser
      signal-desktop
      spotify
      telegram
      xclip
      xournalpp
      zathura
    ];

    # TODO relies on systemd... how to deal with this on non-systemd distros?
    wm_env = mk_coll "wm_env" [
      gui_env
      srcs.i3wm
      i3wm
      # nixpkgs.i3lock # TODO due to PAM perm issue nix version fails
      i3status
      xsession
      jq
      wallpapers
      dunst
      rofi
      wmctrl
      spotify-cli-linux
      xflux
      xrandr-invert-colors
      xorg-xbacklight
      # TODO pulse, viz pactl
      # TODO feh
      # TODO gnome-terminal needs to be manualy configured
      passmenu
    ];

  };

}
