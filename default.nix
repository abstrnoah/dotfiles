inputs@{ ... }:

let
  inherit (inputs.self)
    config packages nixpkgs-packages nixpkgs-unstable-packages;

in let # TODO LEGACY BINDINGS
  lib = inputs.self.config.legacy; # TODO remove this dependency
  inherit (lib) store_text bundle make_source make_nixphile_hook_pre;
  src_path = ./src;
  env_src_path = "$HOME/.dotfiles/src";
  mk_src = name:
    spec@{ excludes ? [ ], ... }:
    let
      # avoid infinite recursion
      rel_excludes = excludes;
    in lib.make_source (spec // rec {
      source = src_path + "/${name}";
      excludes = map (p: source + "/${p}") rel_excludes;
    });
  xrandr-switch-output = name: active: inactive: wallpapers:
    lib.write_script {
      name = "xrandr-switch-${name}";
      text = ''
        xrandr --output ${
          nixpkgs-packages.lib.escapeShellArg active
        } --auto --primary \
               --output ${nixpkgs-packages.lib.escapeShellArg inactive} --off \
               --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };

in let

  upstreams = {
    inherit (nixpkgs-packages)
      apache-jena black bup chromium clang coq cowsay curl diffutils dig discord
      dnstracer dos2unix dunst exiftool fd fdm feh fetchmail findutils fzf gcal
      getconf gimp git gnugrep gnupg gnused hostname htmlq htop hydra-check
      i3status imagemagick img2pdf jdk jq libnotify libreoffice maildrop man mpv
      mutt netcat-openbsd nettools nodejs pandoc par pdfgrep pdftk pfetch procps
      pulseaudio qutebrowser ranger rargs rlwrap rofi sd signal-desktop
      silver-searcher sl slack spotify spotify-cli-linux stow tectonic textql
      thunderbird time tmux tmuxinator toilet tor-browser-bundle-bin tree ttdl
      tuptime udiskie ungoogled-chromium uni universal-ctags util-linux visidata
      wmctrl xclip xflux xournalpp xrandr-invert-colors zathura zbar zsh;
    texlive = nixpkgs-packages.texlive.combined.scheme-small;
    inherit (nixpkgs-packages.nodePackages) insect;
    inherit (nixpkgs-packages.python310Packages) grip weasyprint;
    inherit (nixpkgs-packages.xorg) xbacklight;
    awk = nixpkgs-packages.gawk;
    bat = with nixpkgs-packages;
      bundle "bat" [
        bat
        bat-extras.batdiff
        bat-extras.batman
        bat-extras.batwatch
      ];
    zip = with nixpkgs-packages; bundle "zip" [ zip unzip ];
    ocaml = with nixpkgs-packages;
      bundle "ocaml" [ ocaml ocamlformat ocamlPackages.utop ];
    ssh = nixpkgs-packages.openssh;
    zoom = nixpkgs-packages.zoom-us;
    i3wm = nixpkgs-packages.i3-rounded;
    pinentry = nixpkgs-packages.pinentry-qt;
    vim = nixpkgs-packages.vimHugeX;

    # TODO Move unstable packages to stable as soon as possible.
    inherit (nixpkgs-unstable-packages)
      jabref # Awaiting OpenJDK update.
      # TODO mononoki document fc riffraff
      mononoki # Awaiting version bump to fix recognition issue.
    ;
    telegram =
      nixpkgs-unstable-packages.telegram-desktop; # TODO why on unstable?

    inherit (inputs.nixphile.packages) nixphile;

  };

  ours = {

    ttdl = bundle "ttdl" [ upstreams.ttdl (mk_src "ttdl" { }) ];

    bluetooth = bundle "bluetooth" [ (mk_src "bluetooth" { }) ];

    curl = bundle "curl" [ upstreams.curl (mk_src "curl" { }) ];

    git = bundle "git" [ upstreams.git (mk_src "git" { }) ];

    udiskie = bundle "udiskie" [ upstreams.udiskie (mk_src "udiskie" { }) ];

    # TODO probably should achieve this elsehow
    nix_env_exports = let
      locale_archive =
        "${nixpkgs-packages.glibcLocales}/lib/locale/locale-archive";
    in nixpkgs-packages.writeTextFile rec {
      name = "nix_env_exports";
      text = ''
        export ${
          nixpkgs-packages.lib.toShellVar "LOCALE_ARCHIVE" locale_archive
        }
      '';
      destination = "/lib/${name}";
    };

    tmuxinator =
      bundle "tmuxinator" [ upstreams.tmuxinator (mk_src "tmuxinator" { }) ];

    tmux = bundle "tmux" [
      packages.fzf
      packages.gcal
      packages.tmuxinator
      packages.zsh # TODO rm this dep, it should really point the other direction
      upstreams.tmux
      (mk_src "tmux" { })
    ];

    vim-plug = store_text "${nixpkgs-packages.vimPlugins.vim-plug}/plug.vim"
      "/home/me/.vim/autoload/plug.vim";

    # TODO mutable spellfile
    vim = bundle "vim" [
      packages.curl
      packages.fzf
      packages.vim-plug
      upstreams.vim
      (mk_src "vim" { excludes = [ "/home/me/.vim/spell/en.utf-8.add" ]; })
      (make_nixphile_hook_pre ''
        mkdir -p "$HOME/.vim/spell"
        test -h "$HOME/.vim/spell/en.utf-8.add" \
        || ln -Ts \
          "${env_src_path}/vim/home/me/.vim/spell/en.utf-8.add" \
          "$HOME/.vim/spell/en.utf-8.add"
      '')
    ];

    visidata = bundle "visidata" [ upstreams.visidata (mk_src "visidata" { }) ];

    qutebrowser = bundle "qutebrowser" [
      (upstreams.qutebrowser.overrideAttrs (prev: {
        preFixup = let
          alsaPluginDir =
            (nixpkgs-packages.lib.getLib nixpkgs-packages.alsa-plugins)
            + "/lib/alsa-lib";
          # I don't know much about the following workarounds and don't care to
          # learn because graphics suck. Unfortunately, the third workaround
          # probably comes at a performance cost.
          # (1) QT_XCB_GL_INTEGRATION is a workaround from a while back, idk see
          # commit logs.
          # (2) ALSA_PLUGIN_DIR makes audio work under nix.
          # (3) QT_QUICK_BACKEND is a workaround for Qt6 issue where qutebrowser
          # UI is literally nonexistent.
        in prev.preFixup + ''
          makeWrapperArgs+=(
            --set QT_XCB_GL_INTEGRATION none
            --set ALSA_PLUGIN_DIR "${alsaPluginDir}"
            --set QT_QUICK_BACKEND software
          )
        '';
      }))
      (mk_src "qutebrowser" { })
      (make_nixphile_hook_pre ''
        mkdir -p "$HOME/.config/qutebrowser"
        touch "$HOME/.config/qutebrowser/.keep"
      '')
    ];

    rofi = bundle "rofi" [ upstreams.rofi (mk_src "rofi" { }) ];

    xflux = bundle "xflux" [
      packages.curl
      packages.jq
      upstreams.xflux
      (mk_src "xflux" { })
    ];

    zathura = bundle "zathura" [ upstreams.zathura (mk_src "zathura" { }) ];

    # FIXME video issue
    zoom = upstreams.zoom.overrideAttrs (prev: {
      nativeBuildInputs = (prev.nativeBuildInputs or [ ])
        ++ [ nixpkgs-packages.makeWrapper ];
      postFixup = prev.postFixup + ''
        wrapProgram $out/bin/zoom --set QT_XCB_GL_INTEGRATION none
      '';
    });

    zsh = bundle "zsh" [
      packages.bat
      packages.fd
      packages.fzf
      packages.nix_env_exports
      upstreams.zsh
      (mk_src "zsh" { })
    ];

    i3wm = bundle "i3wm" [ upstreams.i3wm (mk_src "i3wm" { }) ];

    xsession = nixpkgs-packages.writeTextFile {
      name = "xsession";
      text = ''
        exec "${packages.i3wm}/bin/i3"
      '';
      destination = "/home/me/.xsession";
    };

    wallpapers = bundle "wallpapers" [
      (lib.store_file inputs.wallpapers.packages.mount_fuji_jpg
        "/home/me/.wallpaper")
      (lib.store_file inputs.wallpapers.packages.solarized-stars_png
        "/home/me/.wallpaperlock")
    ];

    # bundle bc mk_src returns path not derivation
    passmenu = bundle "passmenu" [ (mk_src "pass" { }) ];

    dunst = bundle "dunst" [ upstreams.dunst (mk_src "dunst" { }) ];

    # TODO do we really want nix's pulse??
    pulseaudio = bundle "pulseaudio" [
      upstreams.pulseaudio
      (mk_src "pulseaudio" { })
      (make_nixphile_hook_pre ''
        mkdir -p "$HOME/.config/pulse"
        touch "$HOME/.config/pulse/.keep"
      '')
    ];

    # TODO this is so hacky it's painful but no time
    # - should lock before hibernating
    # - locking first would require nixifying i3wm-helper-system
    # - there are permission/environment issues: i3lock would probably need to run
    #   under the current user and with DISPLAY set; hibernation needs to run as
    #   root
    # - if i am going to move more things to systemd, then i need to improve the
    #   nix/systemd workflow
    battery_hook_setup = with (import ./src/battery_hook) {
      inherit (config) username;
      nixpkgs = nixpkgs-packages;
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

    captive-browser = (import ./src/captive-browser) {
      inherit bundle;
      nixpkgs = nixpkgs-packages;
    };

    termux.nixphile_hook_pre = lib.write_script {
      name = "setup-termux";
      text = ''
        mkdir -p ~/.termux
        cp "${env_src_path}"/termux/home/me/.termux/* ~/.termux
        cp "${packages.mononoki}/share/fonts/mononoki/mononoki-Regular.ttf" \
            ~/.termux/font.ttf
      '';
    };

    gnupg = (import ./src/gnupg) {
      inherit bundle;
      inherit (nixpkgs-packages) writeTextFile;
      systemd-user-units-path = "/home/me/.config/systemd/user";
      dotfiles-out-path = "/home/me/.dotfiles.out";
    } {
      inherit (upstreams) gnupg;
      inherit (packages) pinentry;
    };

    spotify = bundle "spotify" [ upstreams.spotify packages.spotify-cli-linux ];

  };

  bundles = {

    core_env = with packages;
      bundle "core_env" [
        (make_nixphile_hook_pre ''
          test -d "$HOME/.dotfiles" \
          || git clone -o github \
            https://github.com/abstrnoah/dotfiles \
            "$HOME/.dotfiles"
        '')
        (mk_src "core_env" { })
        (mk_src "nix" { })
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

    default = with packages;
      bundle "default" [
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

    nix-on-droid = with packages;
      bundle "nix-on-droid" [ core_env termux coreutils ssh procps ];

    extras = with packages;
      bundle "extras" [
        insect # Requires x86_64-linux.
        uni
        texlive
        weasyprint
        htmlq
        ungoogled-chromium
        gimp
        zbar
      ];

    gui_env = with packages;
      bundle "gui_env" [
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
    wm_env = with packages;
      bundle "wm_env" [
        gui_env
        i3wm
        # nixpkgs-packages.i3lock # TODO due to PAM perm issue nix version fails
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
        xbacklight
        feh
        passmenu
        zoom
      ];

    coyote = with packages;
      bundle "coyote" [
        extras
        wm_env
        (xrandr-switch-output "builtin" "LVDS1" "VGA1" wallpapers)
        (xrandr-switch-output "external" "VGA1" "LVDS1" wallpapers)
        mononoki
        gnupg # TODO
      ];

  };

in upstreams // ours // bundles
