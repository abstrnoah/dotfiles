inputs@{ self, flake-utils, nixpkgs, nixpkgs-unstable, nixphile, wallpapers, ...
}:

flake-utils.lib.eachDefaultSystem (system:
  let
    this-config = self.config.${system};
    this-nixpkgs = nixpkgs.legacyPackages.${system};
    this-nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

    bundle-dotfiles = this-config.bundle-dotfiles upstreams;
    cons-package = this-config.cons-package this-config packages;
    cons-package-named = this-config.cons-package-named this-config packages;

    upstreams = {
      inherit (this-nixpkgs)
        apache-jena black bup clang coq cowsay curl diffutils dig discord
        dnstracer dos2unix dunst exiftool fd fdm feh fetchmail findutils fzf
        gcal getconf gimp git gnugrep gnupg gnused hostname htmlq htop
        hydra-check i3status imagemagick img2pdf jdk jq libnotify libreoffice
        maildrop man mpv mutt netcat-openbsd nettools nodejs pandoc par pdfgrep
        pdftk pfetch neofetch procps pulseaudio ranger rargs rlwrap
        rofi sd signal-desktop silver-searcher sl slack spotify
        spotify-cli-linux stow tectonic textql thunderbird time tmux tmuxinator
        toilet tor-browser-bundle-bin tree ttdl tuptime udiskie
        ungoogled-chromium uni universal-ctags util-linux visidata wmctrl xclip
        xflux xournalpp xrandr-invert-colors zathura zbar zsh pass
        captive-browser alsa-plugins nixfmt coreutils coreutils-prefixed
        syncthing riseup-vpn;
      chromium = this-nixpkgs.ungoogled-chromium;
      texlive = this-nixpkgs.texlive.combined.scheme-small;
      inherit (this-nixpkgs.nodePackages) insect; # TODO Requires x86_64-linux.
      inherit (this-nixpkgs.python310Packages) grip weasyprint;
      inherit (this-nixpkgs.xorg) xbacklight xrandr;
      awk = this-nixpkgs.gawk;
      bat = this-config.bundle {
        name = "bat";
        packages = {
          inherit (this-nixpkgs) bat;
          inherit (this-nixpkgs.bat-extras) batdiff batman batwatch;
        };
      };
      zip = this-config.bundle {
        name = "zip";
        packages = { inherit (this-nixpkgs) zip unzip; };
      };
      ocaml = this-config.bundle {
        name = "ocaml";
        packages = {
          inherit (this-nixpkgs) ocaml ocamlformat;
          inherit (this-nixpkgs.ocamlPackages) utop;
        };
      };
      ssh = this-nixpkgs.openssh;
      zoom = this-nixpkgs.zoom-us;
      i3wm = this-nixpkgs.i3-rounded;
      pinentry = this-nixpkgs.pinentry-qt;
      vim = this-nixpkgs.vimHugeX;
      # i3lock # TODO nixpkgs version auth fails due to PAM instance mismatch

      # TODO Move unstable packages to stable as soon as possible.
      inherit (this-nixpkgs-unstable)
        jabref # Awaiting OpenJDK update.
        # TODO mononoki document fc riffraff
        mononoki # Awaiting version bump to fix recognition issue.
        qutebrowser # Want those cutting edge features :)
      ;
      telegram = this-nixpkgs-unstable.telegram-desktop; # Want latest features.

      inherit (nixphile.packages.${system}) nixphile;

    };

    ours = {

      ttdl = bundle-dotfiles "ttdl";

      bluetooth = this-config.store-dotfiles "bluetooth";

      curl = bundle-dotfiles "curl";

      git = bundle-dotfiles "git";

      udiskie = bundle-dotfiles "udiskie";

      # TODO probably should achieve this elsehow
      nix_env_exports = let
        locale_archive =
          "${this-nixpkgs.glibcLocales}/lib/locale/locale-archive";
      in this-config.write-text rec {
        name = "nix_env_exports";
        text = ''
          export ${this-nixpkgs.lib.toShellVar "LOCALE_ARCHIVE" locale_archive}
          export QT_XCB_GL_INTEGRATION=none
        '';
        destination = "/lib/${name}";
      };

      tmuxinator = bundle-dotfiles "tmuxinator";

      tmux = this-config.bundle {
        name = "tmux";
        packages = {
          inherit (packages)
            fzf gcal tmuxinator
            zsh # TODO rm this dep, it should really point the other direction
          ;
          inherit (upstreams) tmux;
          tmux-rc = this-config.store-dotfiles "tmux";
        };
      };

      vim-plug = this-config.store-symlink "vim-plug"
        "${this-nixpkgs.vimPlugins.vim-plug}/plug.vim"
        "/home/me/.vim/autoload/plug.vim";

      vim = this-config.bundle {
        name = "vim";
        packages = {
          inherit (packages) curl fzf vim-plug;
          inherit (upstreams) vim;
          vim-rc = this-config.store-dotfiles "vim";
        };
      };

      visidata = bundle-dotfiles "visidata";

      qutebrowser = cons-package-named "qutebrowser" { } {
        inherit (upstreams) qutebrowser;
      };

      rofi = this-config.bundle {
        name = "rofi";
        packages = {
          rofi = upstreams.rofi.override { symlink-dmenu = true; };
          rofi-rc = this-config.store-dotfiles "rofi";
        };
      };

      pass = let
        pass' = upstreams.pass.override {
          inherit (packages) dmenu;
          inherit pass;
        };
        pass = pass'.overrideAttrs (final: prev: {
          patches = prev.patches ++ [
            (this-config.path-append this-config.src-path
              "pass/set-prompt.patch")
          ];
        });
      in pass.withExtensions (es: [ es.pass-otp ]);

      dmenu = packages.rofi;

      xflux = this-config.bundle {
        name = "xflux";
        packages = {
          inherit (packages) curl jq;
          inherit (upstreams) xflux;
          xflux-rc = this-config.store-dotfiles "xflux";
        };
      };

      zathura = bundle-dotfiles "zathura";

      # FIXME video issue
      zoom = upstreams.zoom.overrideAttrs (prev: {
        nativeBuildInputs = (prev.nativeBuildInputs or [ ])
          ++ [ this-nixpkgs.makeWrapper ];
        postFixup = prev.postFixup + ''
          wrapProgram $out/bin/zoom --set QT_XCB_GL_INTEGRATION none
        '';
      });

      zsh = this-config.bundle {
        name = "zsh";
        packages = {
          inherit (packages) bat fd fzf nix_env_exports;
          inherit (upstreams) zsh;
          zsh-rc = this-config.store-dotfiles "zsh";
        };
      };

      i3wm = bundle-dotfiles "i3wm";

      xsession = this-config.write-text {
        name = "xsession";
        text = ''exec "${packages.i3wm}/bin/i3"'';
        destination = "/home/me/.xsession";
      };

      # TODO Replace with direct string interpolation of feh and i3lock commands.
      wallpapers = this-config.store-symlinks {
        name = "wallpapers";
        mapping = [
          {
            source = wallpapers.packages.${system}.mount_fuji_jpg;
            destination = "/home/me/.wallpaper";
          }
          {
            source = inputs.wallpapers.packages.${system}.solarized-stars_png;
            destination = "/home/me/.wallpaperlock";
          }
        ];
      };

      dunst = bundle-dotfiles "dunst";

      pulseaudio = bundle-dotfiles "pulseaudio";

      captive-browser = cons-package-named "captive-browser" { } {
        inherit (upstreams) captive-browser;
      };

      # TODO Reimplement using future nixphile cp tree feature.
      # termux.passthru.before-deploy = this-nixpkgs.write-shell-app {
      #   name = "termux-before-deploy-hook";
      #   text = ''
      #     mkdir -p ~/.termux
      #     cp -p=mode "${config.src-path}"/termux/home/me/.termux/* ~/.termux
      #     cp "${packages.mononoki}/share/fonts/mononoki/mononoki-Regular.ttf" \
      #         ~/.termux/font.ttf
      #   '';
      # };

      gnupg = cons-package-named "gnupg" { } { inherit (upstreams) gnupg; };

      spotify = this-config.bundle {
        name = "spotify";
        packages = {
          inherit (upstreams) spotify;
          inherit (packages) spotify-cli-linux;
        };
      };

      clone-dotfiles = let
        clone-dotfiles-cons =
          config@{ write-shell-app, dotfiles-source, dotfiles-destination }:
          packages@{ git, coreutils-prefixed }:
          write-shell-app {
            name = "clone-dotfiles";
            runtimeInputs = [ git coreutils-prefixed ];
            text = ''
              gtest -d "${dotfiles-destination}" \
              || git clone -o github \
                  "${dotfiles-source}" "${dotfiles-destination}"
            '';
          };
      in cons-package clone-dotfiles-cons { } { };

      nix-rc = this-config.store-dotfiles "nix";

      syncthing = let
        syncthing-cons = config@{ store-symlink, systemd-user-units-path }:
          packages@{ syncthing }:
          this-config.bundle {
            name = "syncthing";
            packages = {
              inherit syncthing;
              syncthing-service = this-config.store-symlink "syncthing-service"
                "${syncthing}/share/systemd/user/syncthing.service"
                "${systemd-user-units-path}/syncthing.service";
            };
          };
      in cons-package syncthing-cons { } { inherit (upstreams) syncthing; };

    };

    bundles = {

      core-env = cons-package-named "core-env" { } { };

      default = this-config.bundle {
        name = "default";
        packages = {
          inherit (packages)
            core-env black bup clang cowsay exiftool gcal imagemagick img2pdf
            ocaml pdftk bluetooth tectonic hydra-check ttdl gnupg pass nixfmt;
        };
      };

      nix-on-droid = this-config.bundle {
        name = "nix-on-droid";
        packages = { inherit (packages) core-env termux ssh procps; };
      };

      extras = this-config.bundle {
        name = "extras";
        packages = {
          inherit (packages)
            insect uni texlive weasyprint htmlq ungoogled-chromium gimp zbar;
        };
      };

      gui-env = this-config.bundle {
        name = "gui-env";
        packages = {
          inherit (packages)
            captive-browser default grip libreoffice mpv pulseaudio qutebrowser
            tor-browser-bundle-bin signal-desktop spotify slack telegram discord
            xclip xournalpp zathura jabref udiskie zoom feh mononoki;
        };
      };

      wm-env = this-config.bundle {
        name = "wm-env";
        packages = {
          inherit (packages)
            gui-env i3wm i3status xsession libnotify jq wallpapers dunst rofi
            wmctrl xflux xrandr-invert-colors xbacklight riseup-vpn;
        };
      };

      coyote = let machine = this-config.machines.coyote;
      in this-config.bundle {
        name = "coyote";
        packages = {
          inherit (packages) wm-env extras syncthing;
          coyote-xrandr-switch =
            cons-package-named "xrandr" { inherit machine; } { };
          battery-hook =
            cons-package-named "battery-hook" { inherit machine; } { };
        };
      };

    };

    packages = upstreams // ours // bundles;

  in { inherit upstreams ours bundles packages; })
