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
  username = "abstrnoah";
  src_path = ./src;
  env_src_path = "$HOME/.dotfiles/src";
  mk_src =
    name:
    spec@{ excludes ? [], ... }:
    let
      # avoid infinite recursion
      rel_excludes = excludes;
    in
    lib.make_source (spec // rec {
      source = src_path + "/${name}";
      excludes = map (p: source + "/${p}") rel_excludes;
    });
  xrandr-switch-output =
    name:
    active:
    inactive:
    wallpapers:
    lib.write_script {
      name = "xrandr-switch-${name}";
      text = ''
        xrandr --output ${nixpkgs.lib.escapeShellArg active} --auto --primary \
               --output ${nixpkgs.lib.escapeShellArg inactive} --off \
               --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };
in
rec {

  nixphile = inputs.nixphile.default;

  # TODO Move unstable packages to stable as soon as possible.
  inherit (nixpkgs_unstable)
  jabref # Awaiting OpenJDK update.
  mononoki # Awaiting version bump to fix recognition issue.
  ;

  inherit (nixpkgs)
  apache-jena
  black
  bup
  chromium
  ungoogled-chromium
  clang
  coq
  cowsay
  diffutils
  dig
  discord
  dnstracer
  dos2unix
  exiftool
  fd
  rargs
  sd
  feh
  fetchmail
  findutils
  fzf
  gimp
  gcal
  getconf
  gnugrep
  gnused
  hostname
  htmlq
  htop
  i3status
  imagemagick
  img2pdf
  jdk
  jq
  libnotify
  libreoffice
  maildrop
  man
  mpv
  mutt
  fdm
  netcat-openbsd
  nettools
  nodejs
  pandoc
  par
  pdfgrep
  pdftk
  pfetch
  procps
  ranger
  rlwrap
  signal-desktop
  silver-searcher
  sl
  slack
  spotify-cli-linux
  stow
  tectonic
  textql
  time
  toilet
  tor-browser-bundle-bin
  tree
  tuptime
  uni
  universal-ctags
  util-linux
  wmctrl
  xclip
  xournalpp
  xrandr-invert-colors
  thunderbird
  hydra-check
  zbar
  # minecraft # broken https://github.com/NixOS/nixpkgs/issues/179323
  ;

  texlive = nixpkgs.texlive.combined.scheme-small;

  inherit (nixpkgs.nodePackages) insect;
  inherit (nixpkgs.python310Packages) grip weasyprint;

  ttdl = bundle "ttdl" [nixpkgs.ttdl (mk_src "ttdl" {})];

  awk = nixpkgs.gawk;

  telegram = nixpkgs_unstable.telegram-desktop;

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

  udiskie = bundle "udiskie" [ nixpkgs.udiskie (mk_src "udiskie" {}) ];

  minecraft = nixpkgs.prismlauncher ;

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
        "${env_src_path}/vim/home/me/.vim/spell/en.utf-8.add" \
        "$HOME/.vim/spell/en.utf-8.add"
    '')
  ];

  visidata = bundle "visidata" [
    nixpkgs.visidata
    (mk_src "visidata" {})
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
          # I don't know much about the following workarounds and don't care to
          # learn because graphics suck. Unfortunately, the third workaround
          # probably comes at a performance cost.
          # (1) QT_XCB_GL_INTEGRATION is a workaround from a while back, idk see
          # commit logs.
          # (2) ALSA_PLUGIN_DIR makes audio work under nix.
          # (3) QT_QUICK_BACKEND is a workaround for Qt6 issue where qutebrowser
          # UI is literally nonexistent.
          prev.preFixup + ''
            makeWrapperArgs+=(
              --set QT_XCB_GL_INTEGRATION none
              --set ALSA_PLUGIN_DIR "${alsaPluginDir}"
              --set QT_QUICK_BACKEND software
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

  i3wm = bundle "i3wm" [nixpkgs.i3-rounded (mk_src "i3wm" {})];

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

  # TODO this is so hacky it's painful but no time
  # - should lock before hibernating
  # - locking first would require nixifying i3wm-helper-system
  # - there are permission/environment issues: i3lock would probably need to run
  #   under the current user and with DISPLAY set; hibernation needs to run as
  #   root
  # - if i am going to move more things to systemd, then i need to improve the
  #   nix/systemd workflow
  battery_hook_setup =
    with
      (import ./src/battery_hook) {
        inherit nixpkgs username;
        battery_device = "BAT0";
        hibernate_command = "systemctl hibernate";
        # TODO We want the following, but it requires i3wm-helper-system be
        # nixified; currently it is too impure to run as a systemd service.
        # hibernate_command = "${i3wm}/bin/i3wm-helper-system hibernate";
      };
    make_nixphile_hook_pre ''
      systemctl reenable ${service}
      systemctl reenable ${timer}
      systemctl start "$(basename ${timer})"
      systemctl start "$(basename ${service})"
    '';

  captive-browser = (import ./src/captive-browser) { inherit nixpkgs bundle; };

  core_env = bundle "core_env" [
    (make_nixphile_hook_pre ''
      test -d "$HOME/.dotfiles" \
      || git clone -o github \
        https://github.com/abstrnoah/dotfiles \
        "$HOME/.dotfiles"
    '')
    (mk_src "core_env" {})
    (mk_src "nix" {})
    awk
    nixphile
    diffutils
    dos2unix
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
    sd
    rargs
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
    par
  ];

  default = bundle "default" [
    core_env
    black
    bup
    clang
    cowsay
    exiftool
    gcal
    imagemagick
    img2pdf
    ocaml
    stow
    pdftk
    bluetooth
    tectonic
    hydra-check
    apache-jena
    util-linux
    ttdl
  ];

  termux.nixphile_hook_pre = lib.write_script {
    name = "setup-termux";
    text = ''
      mkdir -p ~/.termux
      cp "${env_src_path}"/termux/home/me/.termux/* ~/.termux
      cp "${mononoki}/share/fonts/mononoki/mononoki-Regular.ttf" \
          ~/.termux/font.ttf
    '';
  };

  nix-on-droid = bundle "nix-on-droid" [
    core_env
    termux
    nixpkgs.coreutils
    ssh
    nixpkgs.procps
  ];

  extras = bundle "extras" [
    insect # Requires x86_64-linux.
    uni
    texlive
    weasyprint
    htmlq
    ungoogled-chromium
    gimp
    zbar
  ];

  email = bundle "email" [
    thunderbird
  ];

  gui_env = bundle "gui_env" [
    captive-browser
    default
    grip
    libnotify
    libreoffice
    mpv
    pulseaudio
    qutebrowser
    tor-browser-bundle-bin
    signal-desktop
    spotify
    slack
    telegram
    discord
    xclip
    xournalpp
    zathura
    jabref
    udiskie
  ];

  # TODO relies on systemd... how to deal with this on non-systemd distros?
  wm_env = bundle "wm_env" [
    gui_env
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

  coyote = bundle "coyote" [
    email
    extras
    wm_env
    (xrandr-switch-output "builtin" "LVDS1" "VGA1" wallpapers)
    (xrandr-switch-output "external" "VGA1" "LVDS1" wallpapers)
    mononoki # TODO document fc riffraff
  ];

}
