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
        jq
        nodejs
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
        zsh
        nix-zsh-completions
        dmidecode
        pdfgrep
        weechat
        silver-searcher
        fd
        black
        fzf
        clojure
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    clientPackagesGui = pkgs.buildEnv {
      name = "clientPackagesGui";
      paths = [
        jabref
        okular
        xrandr-invert-colors
        zathura
        xournalpp
        # Audio not working for tor.
        torbrowser
        xflux
        qutebrowser
        mpv
        signal-desktop
        spotify
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
