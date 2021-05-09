{
  pulseaudio = true;
  allowUnfreePredicate = pkg: with (import <an_nixpkgs>) {};
  builtins.elem (lib.getName pkg) [
    "zoom"
    "spotify"
    "spotify-unwrapped"
    "ngrok"
    "xflux"
  ];
  packageOverrides = pkgs: with pkgs; {
    clientPackages = pkgs.buildEnv {
      name = "clientPackages";
      paths = [
        maven
        ctags
        git
        glibcLocales
        htop
        jabref
        jq
        nodejs
        okular
        jdk
        pfetch
        php
        python3
        ranger
        rlwrap
        tectonic
        textql
        tmux
        tmuxinator
        toilet
        vimHugeX
        visidata
        xrandr-invert-colors
        zsh
        nix-zsh-completions
        zathura
        dmidecode
        xournalpp
        # Fails to start, missing GLIBC.
        #zoom
        # Unable to communicate with browser, also missing GLIBC.
        #spotify
        # Dependency for 'timer', which I've not added to nixpkgs yet (TODO).
        sox
        pdfgrep
        # Audio not working for tor.
        torbrowser
        weechat
        silver-searcher
        fd
        xflux
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
# TODO: fix PATH and MANPATH so that docs are available to `man`.
