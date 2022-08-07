let
  corePackagePaths = pkgs: with pkgs; [
        bat
        bat-extras.batdiff
        bat-extras.batman
        bat-extras.batwatch
        fd
        fzf
        git
        htop
        jq
        libnotify # TODO tentatively core
        nodePackages.insect
        pdfgrep
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
        universal-ctags
        vimHugeX
        visidata
        xclip # TODO tentatively core
  ];
in
{
  pulseaudio = true;
  allowUnfreePredicate = pkg: with (import <an_nixpkgs>) {};
  builtins.elem (lib.getName pkg) [
    "discord"
    "spotify"
    "spotify-unwrapped"
    "xflux"
    "zoom"
  ];
  packageOverrides = pkgs: {
    clientPackages = pkgs.buildEnv {
      name = "clientPackages";
      paths = with pkgs;
      corePackagePaths pkgs
      ++ [
        anki
        black
        clojure
        cowsay
        delta
        djvu2pdf
        dmidecode
        glibcLocales
        imagemagick
        img2pdf
        jdk
        maven
        nodejs
        php
        python3
        rlwrap
        spotify-cli-linux
        weechat
        xorg.xbacklight
        yq-go
        # zsh
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
    clientPackagesGui = pkgs.buildEnv {
      name = "clientPackagesGui";
      paths = with pkgs; [
        discord
        # jabref # Broke nixos 21.11 -> 22.05.
        mpv
        okular
        qutebrowser
        rofi
        signal-desktop
        spotify
        # tdesktop # telegram-desktop, seems to be out of date atm.
        # tor-browser-bundle-bin # Audio not working for tor.
        wmctrl
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
  # nix-on-droid =
  #   { pkgs }:
  #   {
  #     environment.packages = with pkgs;
  #     [
  #       zsh
  #       vim
  #     ];
  #     system.stateVersion = "22.05"
  #   }
}
