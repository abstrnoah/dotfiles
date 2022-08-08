let
  corePackagePaths = pkgs: with pkgs; [
        bat
        bat-extras.batdiff
        bat-extras.batman
        bat-extras.batwatch
        curl
        fd
        fzf
        git
        glibcLocales
        htop
        jq
        netcat-openbsd
        nettools
        nodejs
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
        # zsh
        anki
        black
        clojure
        cowsay
        delta
        djvu2pdf
        dmidecode
        imagemagick
        img2pdf
        jdk
        maven
        nodePackages.insect
        php
        python3
        rlwrap
        spotify-cli-linux
        weechat
        xorg.xbacklight
        yq-go
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
        discord
        libnotify
        mpv
        okular
        qutebrowser
        rofi
        signal-desktop
        spotify
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
      utillinux
      zsh
    ]);
    environment.etcBackupExtension = ".bak";
    system.stateVersion = "22.05";
    user.shell = "${pkgs.zsh}/bin/zsh";
  };
}
