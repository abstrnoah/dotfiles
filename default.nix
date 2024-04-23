inputs@{ self, flake-utils, nixpkgs, nixpkgs-unstable, nixphile, wallpapers, ...
}:

flake-utils.lib.eachDefaultSystem (system:
  let
    this-config = self.config.${system};
    this-nixpkgs = nixpkgs.legacyPackages.${system};
    this-nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

    bundle-dotfiles = this-config.bundle-dotfiles upstreams;
    cons-package = this-config.cons-package this-config packages;

    upstreams = {
      inherit (this-nixpkgs)
        apache-jena black bup clang coq cowsay curl diffutils dig discord
        dnstracer dos2unix dunst exiftool fd fdm feh fetchmail findutils fzf
        gcal getconf gimp git gnugrep gnupg gnused hostname htmlq htop
        hydra-check i3status imagemagick img2pdf jdk jq libnotify libreoffice
        maildrop man mpv mutt netcat-openbsd nettools nodejs pandoc par pdfgrep
        pdftk pfetch procps pulseaudio qutebrowser ranger rargs rlwrap rofi sd
        signal-desktop silver-searcher sl slack spotify spotify-cli-linux stow
        tectonic textql thunderbird time tmux tmuxinator toilet
        tor-browser-bundle-bin tree ttdl tuptime udiskie ungoogled-chromium uni
        universal-ctags util-linux visidata wmctrl xclip xflux xournalpp
        xrandr-invert-colors zathura zbar zsh pass captive-browser alsa-plugins
        nixfmt;
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
      ;
      telegram = this-nixpkgs-unstable.telegram-desktop; # Want latest features.

      inherit (nixphile.packages.${system}) nixphile;

    };

    ours = {

      ttdl = bundle-dotfiles "ttdl";

      bluetooth = this-config.store-dotfiles ./src/bluetooth;

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
          tmux-rc = this-config.store-dotfiles ./src/tmux;
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
          vim-rc = this-config.store-dotfiles ./src/vim;
        };
      };

      visidata = bundle-dotfiles "visidata";

      qutebrowser = cons-package (import ./src/qutebrowser) { } {
        inherit (upstreams) qutebrowser;
      };

      rofi = this-config.bundle {
        name = "rofi";
        packages = {
          rofi = upstreams.rofi.override { symlink-dmenu = true; };
          rofi-rc = this-config.store-dotfiles ./src/rofi;
        };
      };

      pass = let
        pass' = upstreams.pass.override {
          inherit (packages) dmenu;
          inherit pass;
        };
        pass = pass'.overrideAttrs (final: prev: {
          patches = prev.patches ++ [ ./src/pass/set-prompt.patch ];
        });
      in pass.withExtensions (es: [ es.pass-otp ]);

      dmenu = packages.rofi;

      xflux = this-config.bundle {
        name = "xflux";
        packages = {
          inherit (packages) curl jq;
          inherit (upstreams) xflux;
          xflux-rc = this-config.store-dotfiles ./src/xflux;
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
          zsh-rc = this-config.store-dotfiles ./src/zsh;
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

      # TODO reimplement without hook, require manual installation of system files
      # # TODO this is so hacky it's painful but no time
      # # - should lock before hibernating
      # # - locking first would require nixifying i3wm-helper-system
      # # - there are permission/environment issues: i3lock would probably need to run
      # #   under the current user and with DISPLAY set; hibernation needs to run as
      # #   root
      # # - if i am going to move more things to systemd, then i need to improve the
      # #   nix/systemd workflow
      # battery_hook_setup = with (import ./src/battery_hook) {
      #   inherit (config) username;
      #   nixpkgs = this-nixpkgs;
      #   battery_device = "BAT0";
      #   hibernate_command = "systemctl hibernate";
      #   # TODO We want the following, but it requires i3wm-helper-system be
      #   # nixified; currently it is too impure to run as a systemd service.
      #   # hibernate_command = "${i3wm}/bin/i3wm-helper-system hibernate";
      # };
      #   make_nixphile_hook_pre ''
      #     systemctl reenable ${service}
      #     systemctl reenable ${timer}
      #     systemctl start "$(basename ${timer})"
      #     systemctl start "$(basename ${service})"
      #   '';

      captive-browser = cons-package (import ./src/captive-browser) { } {
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

      gnupg =
        cons-package (import ./src/gnupg) { } { inherit (upstreams) gnupg; };

      spotify = this-config.bundle {
        name = "spotify";
        packages = {
          inherit (upstreams) spotify;
          inherit (packages) spotify-cli-linux;
        };
      };

      clone-dotfiles = this-config.write-shell-app {
        name = "clone-dotfiles";
        text = ''
          test -d "${this-config.dotfiles-destination}" \
          || git clone -o github \
              "${this-config.dotfiles-source}" "${this-config.dotfiles-destination}"
        '';
      };

      nix-rc = this-config.store-dotfiles ./src/nix;

    };

    bundles = {

      core_env = this-config.bundle {
        name = "core_env";
        packages = {
          core-rc = this-config.store-dotfiles ./src/core_env;
          inherit (packages)
            awk nixphile diffutils dos2unix findutils getconf gnugrep gnused
            hostname man bat curl dig dnstracer fd sd rargs fzf git htop jq
            netcat-openbsd nettools nodejs pandoc pdfgrep pfetch ranger
            silver-searcher sl textql time tmux toilet tree tuptime
            universal-ctags zip vim visidata rlwrap par nix-rc;
        };
      };

      default = this-config.bundle {
        name = "default";
        packages = {
          inherit (packages)
            core_env black bup clang cowsay exiftool gcal imagemagick img2pdf
            ocaml stow pdftk bluetooth tectonic hydra-check apache-jena
            util-linux ttdl;
        };
      };

      nix-on-droid = this-config.bundle {
        name = "nix-on-droid";
        packages = { inherit (packages) core_env termux coreutils ssh procps; };
      };

      extras = this-config.bundle {
        name = "extras";
        packages = {
          inherit (packages)
            insect uni texlive weasyprint htmlq ungoogled-chromium gimp zbar;
        };
      };

      gui_env = this-config.bundle {
        name = "gui_env";
        packages = {
          inherit (packages)
            captive-browser default grip libnotify libreoffice mpv pulseaudio
            qutebrowser tor-browser-bundle-bin signal-desktop spotify slack
            telegram discord xclip xournalpp zathura jabref udiskie;
        };
      };

      wm_env = this-config.bundle {
        name = "wm_env";
        packages = {
          inherit (packages)
            gui_env i3wm i3status xsession jq wallpapers dunst rofi wmctrl
            spotify-cli-linux xflux xrandr-invert-colors xbacklight feh zoom;
        };
      };

      coyote = this-config.bundle {
        name = "coyote";
        packages = {
          inherit (packages) extras wm_env mononoki gnupg pass nixfmt;
          coyote-xrandr-switch = cons-package (import ./src/xrandr) {
            machine = this-config.machines.coyote;
          } { };
        };
      };

    };

    packages = upstreams // ours // bundles;

  in { inherit upstreams ours bundles packages; })
