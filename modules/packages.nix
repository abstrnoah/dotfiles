{ moduleWithSystem, ... }:
{
  flake.modules.nixos.base = moduleWithSystem (
    perSystem@{ inputs' }:
    {
      config,
      pkgs,
      utilities,
      library,
      ...
    }:
    let
      inherit (library)
        mkDefault
        mkOption
        types
        ;
      inherit (utilities) mergePackages;
      nixpkgs-packages = pkgs; # TODO
    in
    {

      options.brumal.packages = mkOption {
        type = types.lazyAttrsOf types.package;
        default = { };
      };

      config._module.args.packages = config.brumal.packages;

      config.brumal.packages = mkDefault {

        # Inherit directly from nixpkgs
        inherit (nixpkgs-packages)
          age
          alsa-plugins
          apache-jena
          black
          bup
          captive-browser
          clang
          coq
          coreutils
          coreutils-prefixed
          cowsay
          curl
          dict
          diffutils
          dig
          dnstracer
          dos2unix
          dunst
          exiftool
          fd
          fdm
          feh
          fetchmail
          findutils
          fzf
          gcal
          getconf
          gimp
          git
          gnugrep
          gnupg
          gnused
          hostname
          htmlq
          htop
          hydra-check
          i3status
          imagemagick
          img2pdf
          jabref
          jdk
          jq
          lean4
          libnotify
          libreoffice
          maildrop
          man
          mpv
          mutt
          neofetch
          netcat-openbsd
          nettools
          nnn
          nodejs
          oxigraph
          pandoc
          par
          pass
          pdfgrep
          pdftk
          pfetch
          procps
          pulseaudio
          # rargs # TODO R.I.P. "'rargs' has been removed due to lack of upstream maintenance"
          rclone
          restic
          riseup-vpn
          rlwrap
          rofi
          rustup
          sd
          silver-searcher
          sl
          slack
          spotify
          spotify-cli-linux
          stow
          syncthing
          tectonic
          textql
          thunderbird
          time
          tmux
          tmuxinator
          toilet
          toml2json
          tor-browser-bundle-bin
          tree
          ttdl
          tuptime
          udiskie
          ungoogled-chromium
          uni
          universal-ctags
          util-linux
          visidata
          whatsapp-for-linux
          wireguard-tools
          wmctrl
          xclip
          xflux
          xournalpp
          xrandr-invert-colors
          zathura
          zbar
          zsh
          numbat
          firefox
          glibcLocales
          qutebrowser
          mononoki
          discord
          signal-desktop
          i3lock # TODO nixpkgs version auth fails on debian due to PAM instance mismatch
          ;

        # Aliases to nixpkgs
        awk = nixpkgs-packages.gawk;
        chromium = nixpkgs-packages.ungoogled-chromium;
        i3wm = nixpkgs-packages.i3-rounded;
        neovim = nixpkgs-packages.neovim;
        nixfmt = nixpkgs-packages.nixfmt-rfc-style; # TODO treefmt or whatever?
        pinentry = nixpkgs-packages.pinentry-qt;
        ssh = nixpkgs-packages.openssh;
        texlive = nixpkgs-packages.texlive.combined.scheme-small;
        vim = nixpkgs-packages.vimHugeX;
        zoom = nixpkgs-packages.zoom-us;
        telegram = nixpkgs-packages.telegram-desktop;

        # Inherit from nixpkgs collections
        inherit (nixpkgs-packages.xorg) xbacklight xrandr;
        inherit (nixpkgs-packages.vimPlugins) vim-plug;

        # Mergers of upstreams
        bat = mergePackages {
          name = "bat";
          packages = {
            inherit (nixpkgs-packages) bat;
            inherit (nixpkgs-packages.bat-extras) batdiff batman batwatch;
          };
        };
        zip = mergePackages {
          name = "zip";
          packages = { inherit (nixpkgs-packages) zip unzip; };
        };
        ocaml = mergePackages {
          name = "ocaml";
          packages = {
            inherit (nixpkgs-packages) ocaml ocamlformat;
            inherit (nixpkgs-packages.ocamlPackages) utop;
          };
        };

        # Flake inputs
        inherit (inputs'.nixphile.packages) nixphile;
        inherit (inputs'.emplacetree.packages) emplacetree;

      };

    }
  );
}
