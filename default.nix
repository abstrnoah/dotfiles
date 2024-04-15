inputs@{ ... }:

let inherit (inputs.self) config packages our-nixpkgs our-nixpkgs-unstable;

in let # TODO LEGACY BINDINGS
  lib = inputs.self.config.legacy; # TODO remove this dependency
  inherit (lib) store_text make_source make_nixphile_hook_pre;
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
          our-nixpkgs.lib.escapeShellArg active
        } --auto --primary \
               --output ${our-nixpkgs.lib.escapeShellArg inactive} --off \
               --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };

in let

  upstreams = {
    inherit (our-nixpkgs)
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
    texlive = our-nixpkgs.texlive.combined.scheme-small;
    inherit (our-nixpkgs.nodePackages) insect;
    inherit (our-nixpkgs.python310Packages) grip weasyprint;
    inherit (our-nixpkgs.xorg) xbacklight;
    awk = our-nixpkgs.gawk;
    bat = config.bundle {
      name = "bat";
      packages = {
        inherit (our-nixpkgs) bat;
        inherit (our-nixpkgs.bat-extras) batdiff batman batwatch;
      };
    };
    zip = config.bundle {
      name = "zip";
      packages = { inherit (our-nixpkgs) zip unzip; };
    };
    ocaml = config.bundle {
      name = "ocaml";
      packages = {
        inherit (our-nixpkgs) ocaml ocamlformat;
        inherit (our-nixpkgs.ocamlPackages) utop;
      };
    };
    ssh = our-nixpkgs.openssh;
    zoom = our-nixpkgs.zoom-us;
    i3wm = our-nixpkgs.i3-rounded;
    pinentry = our-nixpkgs.pinentry-qt;
    vim = our-nixpkgs.vimHugeX;

    # TODO Move unstable packages to stable as soon as possible.
    inherit (our-nixpkgs-unstable)
      jabref # Awaiting OpenJDK update.
      # TODO mononoki document fc riffraff
      mononoki # Awaiting version bump to fix recognition issue.
    ;
    telegram = our-nixpkgs-unstable.telegram-desktop; # TODO why on unstable?

    inherit (inputs.nixphile.packages) nixphile;

  };

  ours = {

    ttdl = config.bundle {
      name = "ttdl";
      packages = {
        inherit (upstreams) ttdl;
        ttdl-rc = mk_src "ttdl" { };
      };
    };

    bluetooth = mk_src "bluetooth" { };

    curl = config.bundle {
      name = "curl";
      packages = {
        inherit (upstreams) curl;
        curl-rc = mk_src "curl" { };
      };
    };

    git = config.bundle {
      name = "git";
      packages = {
        inherit (upstreams) git;
        git-rc = mk_src "git" { };
      };
    };

    udiskie = config.bundle {
      name = "udiskie";
      packages = {
        inherit (upstreams) udiskie;
        udiskie-rc = mk_src "udiskie" { };
      };
    };

    # TODO probably should achieve this elsehow
    nix_env_exports = let
      locale_archive = "${our-nixpkgs.glibcLocales}/lib/locale/locale-archive";
    in our-nixpkgs.writeTextFile rec {
      name = "nix_env_exports";
      text = ''
        export ${our-nixpkgs.lib.toShellVar "LOCALE_ARCHIVE" locale_archive}
      '';
      destination = "/lib/${name}";
    };

    tmuxinator = config.bundle {
      name = "tmuxinator";
      packages = {
        inherit (upstreams) tmuxinator;
        tmuxinator-rc = mk_src "tmuxinator" { };
      };
    };

    tmux = config.bundle {
      name = "tmux";
      packages = {
        inherit (packages)
          fzf gcal tmuxinator
          zsh # TODO rm this dep, it should really point the other direction
        ;
        inherit (upstreams) tmux;
        tmux-rc = mk_src "tmux" { };
      };
    };

    vim-plug = store_text "${our-nixpkgs.vimPlugins.vim-plug}/plug.vim"
      "/home/me/.vim/autoload/plug.vim";

    # TODO mutable spellfile
    vim = config.bundle {
      name = "vim";
      packages = {
        inherit (packages) curl fzf vim-plug;
        inherit (upstreams) vim;
        vim-rc =
          mk_src "vim" { excludes = [ "/home/me/.vim/spell/en.utf-8.add" ]; };
        vim-nixphile-hook = (make_nixphile_hook_pre ''
          mkdir -p "$HOME/.vim/spell"
          test -h "$HOME/.vim/spell/en.utf-8.add" \
          || ln -Ts \
          "${env_src_path}/vim/home/me/.vim/spell/en.utf-8.add" \
          "$HOME/.vim/spell/en.utf-8.add"
        '');
      };
    };

    visidata = config.bundle {
      name = "visidata";
      packages = {
        inherit (upstreams) visidata;
        visidata-rc = mk_src "visidata" { };
      };
    };

    qutebrowser = config.bundle {
      name = "qutebrowser";
      packages = {
        qutebrowser = (upstreams.qutebrowser.overrideAttrs (prev: {
          preFixup = let
            alsaPluginDir = (our-nixpkgs.lib.getLib our-nixpkgs.alsa-plugins)
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
        }));
        qutebrowser-rc = (mk_src "qutebrowser" { });
        qutebrowser-nixphile-hook = (make_nixphile_hook_pre ''
          mkdir -p "$HOME/.config/qutebrowser"
          touch "$HOME/.config/qutebrowser/.keep"
        '');
      };
    };

    rofi = config.bundle {
      name = "rofi";
      packages = {
        inherit (upstreams) rofi;
        rofi-rc = (mk_src "rofi" { });
      };
    };

    xflux = config.bundle {
      name = "xflux";
      packages = {
        inherit (packages) curl jq;
        inherit (upstreams) xflux;
        xflux-rc = (mk_src "xflux" { });
      };
    };

    zathura = config.bundle {
      name = "zathura";
      packages = {
        inherit (upstreams) zathura;
        zathura-rc = (mk_src "zathura" { });
      };
    };

    # FIXME video issue
    zoom = upstreams.zoom.overrideAttrs (prev: {
      nativeBuildInputs = (prev.nativeBuildInputs or [ ])
        ++ [ our-nixpkgs.makeWrapper ];
      postFixup = prev.postFixup + ''
        wrapProgram $out/bin/zoom --set QT_XCB_GL_INTEGRATION none
      '';
    });

    zsh = config.bundle {
      name = "zsh";
      packages = {
        inherit (packages) bat fd fzf nix_env_exports;
        inherit (upstreams) zsh;
        zsh-rc = (mk_src "zsh" { });
      };
    };

    i3wm = config.bundle {
      name = "i3wm";
      packages = {
        inherit (upstreams) i3wm;
        i3wm-rc = (mk_src "i3wm" { });
      };
    };

    xsession = our-nixpkgs.writeTextFile {
      name = "xsession";
      text = ''
        exec "${packages.i3wm}/bin/i3"
      '';
      destination = "/home/me/.xsession";
    };

    wallpapers = config.bundle {
      name = "wallpapers";
      packages = {
        wallpaper-home =
          (lib.store_file inputs.wallpapers.packages.mount_fuji_jpg
            "/home/me/.wallpaper");
        wallpaper-lock =
          (lib.store_file inputs.wallpapers.packages.solarized-stars_png
            "/home/me/.wallpaperlock");
      };
    };

    passmenu = mk_src "pass" { };

    dunst = config.bundle {
      name = "dunst";
      packages = {
        inherit (upstreams) dunst;
        dunst-rc = (mk_src "dunst" { });
      };
    };

    # TODO do we really want nix's pulse??
    pulseaudio = config.bundle {
      name = "pulseaudio";
      packages = {
        inherit (upstreams) pulseaudio;
        pulseaudio-rc = (mk_src "pulseaudio" { });
        pulseaudio-nixphile-hook = (make_nixphile_hook_pre ''
          mkdir -p "$HOME/.config/pulse"
          touch "$HOME/.config/pulse/.keep"
        '');
      };
    };

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
      nixpkgs = our-nixpkgs;
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

    captive-browser = import ./src/captive-browser {
      inherit (lib) bundle;
      nixpkgs = our-nixpkgs;
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

    gnupg = import ./src/gnupg {
      inherit (lib) bundle;
      inherit (our-nixpkgs) writeTextFile;
      systemd-user-units-path = "/home/me/.config/systemd/user";
      dotfiles-out-path = "/home/me/.dotfiles.out";
    } {
      inherit (upstreams) gnupg;
      inherit (packages) pinentry;
    };

    spotify = config.bundle {
      name = "spotify";
      packages = {
        inherit (upstreams) spotify;
        inherit (packages) spotify-cli-linux;
      };
    };

  };

  bundles = {

    core_env = config.bundle {
      name = "core_env";
      packages = {
        core-env-nixphile-hook = (make_nixphile_hook_pre ''
          test -d "$HOME/.dotfiles" \
          || git clone -o github \
          https://github.com/abstrnoah/dotfiles \
          "$HOME/.dotfiles"
        '');
        core-rc = (mk_src "core_env" { });
        nix-rc = (mk_src "nix" { });
        inherit (packages)
          awk nixphile diffutils dos2unix findutils getconf gnugrep gnused
          hostname man bat curl dig dnstracer fd sd rargs fzf git htop jq
          netcat-openbsd nettools nodejs pandoc pdfgrep pfetch ranger
          silver-searcher sl textql time tmux toilet tree tuptime
          universal-ctags zip vim visidata rlwrap par;
      };
    };

    default = config.bundle {
      name = "default";
      packages = {
        inherit (packages)
          core_env black bup clang cowsay exiftool gcal imagemagick img2pdf
          ocaml stow pdftk bluetooth tectonic hydra-check apache-jena util-linux
          ttdl;
      };
    };

    nix-on-droid = config.bundle {
      name = "nix-on-droid";
      packages = { inherit (packages) core_env termux coreutils ssh procps; };
    };

    extras = config.bundle {
      name = "extras";
      packages = {
        inherit (packages)
          insect # TODO Requires x86_64-linux.
          uni texlive weasyprint htmlq ungoogled-chromium gimp zbar;
      };
    };

    gui_env = config.bundle {
      name = "gui_env";
      packages = {
        inherit (packages)
          captive-browser default grip libnotify libreoffice mpv pulseaudio
          qutebrowser tor-browser-bundle-bin signal-desktop spotify slack
          telegram discord xclip xournalpp zathura jabref udiskie;
      };
    };

    # TODO relies on systemd... how to deal with this on non-systemd distros?
    wm_env = config.bundle {
      name = "wm_env";
      packages = {
        inherit (packages)
          gui_env i3wm
          # our-nixpkgs.i3lock # TODO due to PAM perm issue nix version fails
          i3status xsession jq wallpapers dunst rofi wmctrl spotify-cli-linux
          xflux xrandr-invert-colors xbacklight feh passmenu zoom;
      };
    };

    coyote = config.bundle {
      name = "coyote";
      packages = {
        inherit (packages) extras wm_env mononoki gnupg; # TODO
        xrandr-switch-builtin =
          (xrandr-switch-output "builtin" "LVDS1" "VGA1" packages.wallpapers);
        xrandr-switch-external =
          (xrandr-switch-output "external" "VGA1" "LVDS1" packages.wallpapers);
      };
    };

  };

in upstreams // ours // bundles
