let
  corePackagePaths = pkgs:
    with pkgs; [
      bat
      bat-extras.batdiff
      bat-extras.batman
      bat-extras.batwatch
      curl
      dig
      dnstracer
      fd
      fzf
      git
      glibcLocales
      # gnupg # version conflict due to systemd supervision of gpg-agent
      htop
      jq
      netcat-openbsd
      nettools
      nodejs
      pandoc
      # pass # see gnupg issue
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
      tmuxinator
      toilet
      tree
      tuptime
      universal-ctags
      unzip
      vimHugeX
      visidata
      zip
    ];
in {
  pulseaudio = true;
  allowUnfreePredicate = pkg:
    with (import <an_nixpkgs>) { };
    builtins.elem (lib.getName pkg) [
      "discord"
      "spotify"
      "spotify-unwrapped"
      "vscode"
      "xflux"
      "zoom"
    ];
  packageOverrides = pkgs: {
    clientPackages = pkgs.buildEnv {
      name = "clientPackages";
      paths = with pkgs;
        corePackagePaths pkgs ++ [
          # anki (needs QT_XCB_GL_INTEGRATION=none workaround)
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
          nodePackages.insect
          ocaml
          ocamlformat
          ocamlPackages.utop
          php
          python3
          # qemu
          rlwrap
          spotify-cli-linux
          sqlfluff
          stow
          texlive.combined.scheme-small
          weechat
          wego
          # wkhtmltopdf # needs deprecated webkit
          xorg.xbacklight
          yj
          yq-go
          # zsh
        ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    clientPackagesGui = pkgs.buildEnv {
      name = "clientPackagesGui";
      paths = with pkgs; [
        # jabref # Broke nixos 21.11 -> 22.05.
        # tdesktop # telegram-desktop, seems to be out of date atm.
        # tor-browser-bundle-bin # Audio not working for tor.
        # discord
        libnotify
        mpv
        okular
        python310Packages.grip
        qutebrowser
        rofi
        signal-desktop
        spotify
        thunderbird
        wmctrl
        xclip
        xflux
        xournalpp
        xrandr-invert-colors
        zathura
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    # serverPackages = pkgs.buildEnv {
    #   name = "serverPackages";
    #   paths = [
    #     # Nothing here for now! Currently all server applications seem to need
    #     # to be installed via the native package manager.
    #   ];
    #   pathsToLink = [ "/share" "/bin" "/lib" ];
    #   extraOutputsToInstall = [ "man" "doc" ];
    # };
  };
  nix-on-droid = { pkgs, ... }: {
    environment.packages = (corePackagePaths pkgs) ++ (with pkgs; [
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
      zsh
    ]);
    environment.etcBackupExtension = ".bak";
    system.stateVersion = "22.05";
    user.shell = "${pkgs.zsh}/bin/zsh";
  };
}
