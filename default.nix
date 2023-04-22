# TODO
# - xclip? non-x-reliant clipboard manager?
# - speedup, namely rewrite `bundle` and reduce core_env
inputs@{
  lib
, nixpkgs
, nixpkgs_unstable
, system ? builtins.currentSystem # TODO maybe improve how we handle system
, nixphile
, wallpapers
, ...
}:

with {
  inherit (lib)
  by_name
  get
  store_text
  make_env
  bundle
  make_source
  make_nixphile_hook_pre
  ;
};
let
  dotfiles_path = ./dotfiles;
  mk_src =
    name:
    spec@{ excludes ? [], ... }:
    let
      # avoid infinite recursion
      rel_excludes = excludes;
    in
    lib.make_source (spec // rec {
      source = dotfiles_path + "/${name}";
      excludes = map (p: source + "/${p}") rel_excludes;
    });
  xrandr-switch-output =
    name:
    active:
    inactive:
    lib.write_script {
      name = "xrandr-switch-${name}";
      text = ''
        xrandr --output ${nixpkgs.lib.escapeShellArg active} --auto \
               --output ${nixpkgs.lib.escapeShellArg inactive} --off
      '';
    };
in
rec {

  nixphile = inputs.nixphile.default;

  # TODO Move unstable packages to stable as soon as possible.
  inherit (nixpkgs_unstable)
  jabref # Awaiting OpenJDK update.
  ;

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
  feh
  findutils
  fzf
  gcal
  getconf
  gnugrep
  gnused
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
  toilet
  tor-browser-bundle-bin
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
  inherit (nixpkgs.python310Packages) grip;

  telegram = nixpkgs.tdesktop;

  xorg-xbacklight = nixpkgs.xorg.xbacklight;

  bat = bundle "bat" [
    nixpkgs.bat
    nixpkgs.bat-extras.batdiff
    nixpkgs.bat-extras.batman
    nixpkgs.bat-extras.batwatch
  ];

  bluetooth = bundle "bluetooth" [ (mk_src "bluetooth" {}) ];

  curl = bundle "curl" [ nixpkgs.curl (mk_src "curl" {}) ];

  git = bundle "git" [ nixpkgs.git (mk_src "git" {}) ];

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

  tmuxinator = bundle "tmuxinator" [
    nixpkgs.tmuxinator
    (mk_src "tmuxinator" {})
  ];

  tmux = bundle "tmux" [
    fzf
    gcal
    nixpkgs.tmux
    (mk_src "tmux" {})
    tmuxinator
    zsh # TODO rm this dep
  ];

  zip = bundle "zip" [ nixpkgs.zip nixpkgs.unzip ];

  vim-plug =
    store_text
    "${nixpkgs.vimPlugins.vim-plug}/plug.vim"
    "/home/me/.vim/autoload/plug.vim";

  # TODO mutable spellfile
  vim = bundle "vim" [
    curl
    fzf
    nixpkgs.vimHugeX
    (mk_src "vim" { excludes = [ "/home/me/.vim/spell/en.utf-8.add" ]; })
    vim-plug
    (make_nixphile_hook_pre ''
      mkdir -p "$HOME/.vim/spell"
      test -h "$HOME/.vim/spell/en.utf-8.add" \
      || ln -Ts \
        "$HOME/.dotfiles/dotfiles/vim/home/me/.vim/spell/en.utf-8.add" \
        "$HOME/.vim/spell/en.utf-8.add"
    '')
  ];

  ocaml = bundle "ocaml" [
    nixpkgs.ocaml
    nixpkgs.ocamlformat
    nixpkgs.ocamlPackages.utop
  ];

  qutebrowser = bundle "qutebrowser" [
    (nixpkgs.qutebrowser.overrideAttrs (prev: {
        preFixup =
          let
            alsaPluginDir = (nixpkgs.lib.getLib nixpkgs.alsa-plugins) + "/lib/alsa-lib";
          in
          prev.preFixup + ''
            makeWrapperArgs+=(
              --set QT_XCB_GL_INTEGRATION none
              --set ALSA_PLUGIN_DIR "${alsaPluginDir}"
            )
          '';
    }))
    (mk_src "qutebrowser" {})
    (make_nixphile_hook_pre ''
      mkdir -p "$HOME/.config/qutebrowser"
      touch "$HOME/.config/qutebrowser/.keep"
    '')
  ];

  rofi = bundle "rofi" [ nixpkgs.rofi (mk_src "rofi" {}) ];

  spotify = bundle "spotify" [ nixpkgs.spotify spotify-cli-linux ];

  xflux = bundle "xflux" [
    curl
    jq
    nixpkgs.xflux
    (mk_src "xflux" {})
  ];

  zathura = bundle "zathura" [ nixpkgs.zathura (mk_src "zathura" {}) ];

  # FIXME video issue
  zoom = nixpkgs.zoom-us.overrideAttrs (prev: {
    nativeBuildInputs = (prev.nativeBuildInputs or []) ++ [ nixpkgs.makeWrapper ];
    postFixup = prev.postFixup + ''
      wrapProgram $out/bin/zoom --set QT_XCB_GL_INTEGRATION none
    '';
  });

  zsh = bundle "zsh" [
    bat
    fd
    fzf
    nix_env_exports
    nixpkgs.zsh
    (mk_src "zsh" {})
  ];

  i3wm = nixpkgs.i3-rounded;

  xsession = nixpkgs.writeTextFile {
    name = "xsession";
    text = ''
      exec "${i3wm}/bin/i3"
    '';
    destination = "/home/me/.xsession";
  };

  wallpapers = bundle "wallpapers" [
    (lib.store_file
    inputs.wallpapers.mount_fuji_jpg
    "/home/me/.wallpaper")
    (lib.store_file
    inputs.wallpapers.solarized-stars_png
    "/home/me/.wallpaperlock")
  ];

  # bundle bc mk_src returns path not derivation
  passmenu = bundle "passmenu" [ (mk_src "pass" {}) ];

  dunst = bundle "dunst" [ nixpkgs.dunst (mk_src "dunst" {}) ];

  # TODO do we really want nix's pulse??
  pulseaudio = bundle "pulseaudio" [
    nixpkgs.pulseaudio
    (mk_src "pulseaudio" {})
    (make_nixphile_hook_pre ''
      mkdir -p "$HOME/.config/pulse"
      touch "$HOME/.config/pulse/.keep"
    '')
  ];

  ssh = nixpkgs.openssh;

  nix-on-droid = bundle "nix-on-droid" [
    core_env
    ssh
    procps
    utillinux
  ];

  core_env = bundle "core_env" [
    (make_nixphile_hook_pre ''
      test -d "$HOME/.dotfiles" \
      || git clone -o github \
        https://github.com/abstrnoah/dotfiles \
        "$HOME/.dotfiles"
    '')
    (mk_src "core_env" {})
    (mk_src "nix" {})
    nixphile
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

  default = bundle "default" [
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
    stow
    jdk
    pdftk
    bluetooth
  ];

  gui_env = bundle "gui_env" [
    default
    grip
    libnotify
    mpv
    pulseaudio
    qutebrowser
    tor-browser-bundle-bin
    signal-desktop
    spotify
    telegram
    xclip
    xournalpp
    zathura
    jabref
  ];

  # TODO relies on systemd... how to deal with this on non-systemd distros?
  wm_env = bundle "wm_env" [
    gui_env
    (mk_src "i3wm" {})
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
    feh
    passmenu
    zoom
  ];

  machine03 = bundle "machine03" [
    wm_env
    (xrandr-switch-output "builtin" "LVDS1" "VGA1")
    (xrandr-switch-output "external" "VGA1" "LVDS1")
  ];

}
