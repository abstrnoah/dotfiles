inputs@{ self, flake-utils, nixpkgs, nixpkgs-unstable, nixphile, wallpapers, ...
}:

flake-utils.lib.eachDefaultSystem (system:
  let
    config-system = self.config.${system};
    nixpkgs-system = nixpkgs.legacyPackages.${system};
    nixpkgs-unstable-system = nixpkgs-unstable.legacyPackages.${system};

    bundle-dotfiles = config-system.bundle-dotfiles upstreams;
    cons-package = config-system.cons-package config-system packages;

    upstreams = {
      inherit (nixpkgs-system)
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
      chromium = nixpkgs-system.ungoogled-chromium;
      texlive = nixpkgs-system.texlive.combined.scheme-small;
      inherit (nixpkgs-system.nodePackages)
        insect; # TODO Requires x86_64-linux.
      inherit (nixpkgs-system.python310Packages) grip weasyprint;
      inherit (nixpkgs-system.xorg) xbacklight xrandr;
      awk = nixpkgs-system.gawk;
      bat = config-system.bundle {
        name = "bat";
        packages = {
          inherit (nixpkgs-system) bat;
          inherit (nixpkgs-system.bat-extras) batdiff batman batwatch;
        };
      };
      zip = config-system.bundle {
        name = "zip";
        packages = { inherit (nixpkgs-system) zip unzip; };
      };
      ocaml = config-system.bundle {
        name = "ocaml";
        packages = {
          inherit (nixpkgs-system) ocaml ocamlformat;
          inherit (nixpkgs-system.ocamlPackages) utop;
        };
      };
      ssh = nixpkgs-system.openssh;
      zoom = nixpkgs-system.zoom-us;
      i3wm = nixpkgs-system.i3-rounded;
      pinentry = nixpkgs-system.pinentry-qt;
      vim = nixpkgs-system.vimHugeX;
      # i3lock # TODO nixpkgs version auth fails due to PAM instance mismatch

      # TODO Move unstable packages to stable as soon as possible.
      inherit (nixpkgs-unstable-system)
        jabref # Awaiting OpenJDK update.
        # TODO mononoki document fc riffraff
        mononoki # Awaiting version bump to fix recognition issue.
      ;
      telegram =
        nixpkgs-unstable-system.telegram-desktop; # Want latest features.

      inherit (nixphile.packages.${system}) nixphile;

    };

    ours = {

      ttdl = bundle-dotfiles "ttdl";

      bluetooth = config-system.store-dotfiles ./src/bluetooth;

      curl = bundle-dotfiles "curl";

      git = bundle-dotfiles "git";

      udiskie = bundle-dotfiles "udiskie";

      # TODO probably should achieve this elsehow
      nix_env_exports = let
        locale_archive =
          "${nixpkgs-system.glibcLocales}/lib/locale/locale-archive";
      in nixpkgs-system.writeTextFile rec {
        name = "nix_env_exports";
        text = ''
          export ${
            nixpkgs-system.lib.toShellVar "LOCALE_ARCHIVE" locale_archive
          }
        '';
        destination = "/lib/${name}";
      };

      tmuxinator = bundle-dotfiles "tmuxinator";

      tmux = config-system.bundle {
        name = "tmux";
        packages = {
          inherit (packages)
            fzf gcal tmuxinator
            zsh # TODO rm this dep, it should really point the other direction
          ;
          inherit (upstreams) tmux;
          tmux-rc = config-system.store-dotfiles ./src/tmux;
        };
      };

      vim-plug = config-system.store-symlink "vim-plug"
        "${nixpkgs-system.vimPlugins.vim-plug}/plug.vim"
        "/home/me/.vim/autoload/plug.vim";

      vim = config-system.bundle {
        name = "vim";
        packages = {
          inherit (packages) curl fzf vim-plug;
          inherit (upstreams) vim;
          vim-rc = config-system.store-dotfiles ./src/vim;
        };
      };

      visidata = bundle-dotfiles "visidata";

      qutebrowser = cons-package (import ./src/qutebrowser) { } {
        inherit (upstreams) qutebrowser;
      };

      rofi = config-system.bundle {
        name = "rofi";
        packages = {
          rofi = upstreams.rofi.override { symlink-dmenu = true; };
          rofi-rc = config-system.store-dotfiles ./src/rofi;
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

      xflux = config-system.bundle {
        name = "xflux";
        packages = {
          inherit (packages) curl jq;
          inherit (upstreams) xflux;
          xflux-rc = config-system.store-dotfiles ./src/xflux;
        };
      };

      zathura = bundle-dotfiles "zathura";

      # FIXME video issue
      zoom = upstreams.zoom.overrideAttrs (prev: {
        nativeBuildInputs = (prev.nativeBuildInputs or [ ])
          ++ [ nixpkgs-system.makeWrapper ];
        postFixup = prev.postFixup + ''
          wrapProgram $out/bin/zoom --set QT_XCB_GL_INTEGRATION none
        '';
      });

      zsh = config-system.bundle {
        name = "zsh";
        packages = {
          inherit (packages) bat fd fzf nix_env_exports;
          inherit (upstreams) zsh;
          zsh-rc = config-system.store-dotfiles ./src/zsh;
        };
      };

      i3wm = bundle-dotfiles "i3wm";

      xsession = nixpkgs-system.writeTextFile {
        name = "xsession";
        text = ''
          exec "${packages.i3wm}/bin/i3"
        '';
        destination = "/home/me/.xsession";
      };

      # TODO Replace with direct string interpolation of feh and i3lock commands.
      wallpapers = config-system.store-symlinks {
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
      #   nixpkgs = nixpkgs-system;
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
      # termux.passthru.before-deploy = nixpkgs-system.writeShellApplication {
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

      spotify = config-system.bundle {
        name = "spotify";
        packages = {
          inherit (upstreams) spotify;
          inherit (packages) spotify-cli-linux;
        };
      };

      clone-dotfiles = nixpkgs-system.writeShellApplication {
        name = "clone-dotfiles";
        text = ''
          test -d "${config-system.dotfiles-destination}" \
          || git clone -o github \
              "${config-system.dotfiles-source}" "${config-system.dotfiles-destination}"
        '';
      };

      nix-rc = config-system.store-dotfiles ./src/nix;

    };

    bundles = {

      core_env = config-system.bundle {
        name = "core_env";
        packages = {
          core-rc = config-system.store-dotfiles ./src/core_env;
          inherit (packages)
            awk nixphile diffutils dos2unix findutils getconf gnugrep gnused
            hostname man bat curl dig dnstracer fd sd rargs fzf git htop jq
            netcat-openbsd nettools nodejs pandoc pdfgrep pfetch ranger
            silver-searcher sl textql time tmux toilet tree tuptime
            universal-ctags zip vim visidata rlwrap par nix-rc;
        };
      };

      default = config-system.bundle {
        name = "default";
        packages = {
          inherit (packages)
            core_env black bup clang cowsay exiftool gcal imagemagick img2pdf
            ocaml stow pdftk bluetooth tectonic hydra-check apache-jena
            util-linux ttdl;
        };
      };

      nix-on-droid = config-system.bundle {
        name = "nix-on-droid";
        packages = { inherit (packages) core_env termux coreutils ssh procps; };
      };

      extras = config-system.bundle {
        name = "extras";
        packages = {
          inherit (packages)
            insect uni texlive weasyprint htmlq ungoogled-chromium gimp zbar;
        };
      };

      gui_env = config-system.bundle {
        name = "gui_env";
        packages = {
          inherit (packages)
            captive-browser default grip libnotify libreoffice mpv pulseaudio
            qutebrowser tor-browser-bundle-bin signal-desktop spotify slack
            telegram discord xclip xournalpp zathura jabref udiskie;
        };
      };

      wm_env = config-system.bundle {
        name = "wm_env";
        packages = {
          inherit (packages)
            gui_env i3wm i3status xsession jq wallpapers dunst rofi wmctrl
            spotify-cli-linux xflux xrandr-invert-colors xbacklight feh zoom;
        };
      };

      coyote = config-system.bundle {
        name = "coyote";
        packages = {
          inherit (packages) extras wm_env mononoki gnupg pass nixfmt;
          coyote-xrandr-switch = cons-package (import ./src/xrandr) {
            machine = config-system.machines.coyote;
          } { };
        };
      };

    };

    packages = upstreams // ours // bundles;

  in { inherit upstreams ours bundles packages; })
