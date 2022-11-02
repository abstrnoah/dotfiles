let
  corePackagePaths = pkgs: with pkgs; [
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
    htop
    jq
    netcat-openbsd
    nettools
    nodejs
    pandoc
    pdfgrep
    pdftk
    pfetch
    ranger
    silver-searcher
    sl
    tectonic
    textql
    tmux
    tmuxinator
    toilet
    tree
    tuptime
    universal-ctags
    vimHugeX
    visidata
  ];
in
{
  pulseaudio = true;
  allowUnfreePredicate = pkg: with (import <an_nixpkgs>) {};
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
      corePackagePaths pkgs
      ++ [
        # anki (needs QT_XCB_GL_INTEGRATION=none workaround)
        black
        clang_10 # version 10 so consistent with labradoodle.caltech.edu
        clojure
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
        php
        python3
        rlwrap
        spotify-cli-linux
        stow
        weechat
        wego
        wkhtmltopdf
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
        qutebrowser
        rofi
        signal-desktop
        spotify
        vscode
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
    environment.packages = (corePackagePaths pkgs)
    ++ (with pkgs; [
      diffutils
      findutils
      getconf
      gnugrep
      gnused
      hostname
      man
      openssh
      procps
      unzip
      utillinux
      zsh
    ]);
    environment.etcBackupExtension = ".bak";
    system.stateVersion = "22.05";
    user.shell = "${pkgs.zsh}/bin/zsh";
  };
}
