{
  pulseaudio = true;
  allowUnfreePredicate = pkg: with (import <an_nixpkgs>) {};
  builtins.elem (lib.getName pkg) [
    "spotify"
    "spotify-unwrapped"
    "xflux"
    "zoom"
  ];
  packageOverrides = pkgs: with pkgs; {
    clientPackages = pkgs.buildEnv {
      name = "clientPackages";
      paths = [
        bat
        bat-extras.batdiff
        bat-extras.batman
        bat-extras.batwatch
        black
        clojure
        cowsay
        delta
        djvu2pdf
        dmidecode
        fd
        fzf
        git
        glibcLocales
        htop
        imagemagick
        img2pdf
        jdk
        jq
        libnotify
        maven
        nodejs
        nodePackages.insect
        pdfgrep
        pfetch
        php
        python3
        ranger
        rlwrap
        silver-searcher
        sl
        spotify-cli-linux
        tectonic
        textql
        tmux
        tmuxinator
        toilet
        tree
        tudu
        universal-ctags
        vimHugeX
        visidata
        weechat
        xclip
        xorg.xbacklight
        yq-go
        # zsh
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    clientPackagesGui = pkgs.buildEnv {
      name = "clientPackagesGui";
      paths = [
        # jabref # Broke nixos 21.11 -> 22.05.
        mpv
        okular
        qutebrowser
        rofi
        signal-desktop
        spotify
        # tor-browser-bundle-bin # Audio not working for tor.
        xflux
        xournalpp
        xrandr-invert-colors
        zathura
        # tdesktop # telegram-desktop, seems to be out of date atm.
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    serverPackages = pkgs.buildEnv {
      name = "serverPackages";
      paths = [
        # Nothing here for now! Currently all server applications seem to need
        # to be installed via the native package manager.
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
