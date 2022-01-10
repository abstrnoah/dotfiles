{
  pulseaudio = true;
  allowUnfreePredicate = pkg: with (import <an_nixpkgs>) {};
  builtins.elem (lib.getName pkg) [
    "ngrok"
    "spotify"
    "spotify-unwrapped"
    "xflux"
    "zoom"
  ];
  packageOverrides = pkgs: with pkgs; {
    clientPackages = pkgs.buildEnv {
      name = "clientPackages";
      paths = [
        black
        clojure
        ctags
        dmidecode
        fd
        fzf
        git
        glibcLocales
        htop
        jdk
        jq
        maven
        nix-zsh-completions
        nodejs
        pdfgrep
        pfetch
        php
        python3
        ranger
        rlwrap
        silver-searcher
        tectonic
        textql
        tmux
        tmuxinator
        toilet
        tree
        tudu
        vimHugeX
        visidata
        weechat
        yq-go
        zsh
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    clientPackagesGui = pkgs.buildEnv {
      name = "clientPackagesGui";
      paths = [
        jabref
        mpv
        okular
        qutebrowser
        rofi
        signal-desktop
        spotify
        torbrowser # Audio not working for tor.
        xflux
        xournalpp
        xrandr-invert-colors
        zathura
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
