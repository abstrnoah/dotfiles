{
  pulseaudio = true;
  allowUnfreePredicate = pkg: with (import <an_nixpkgs>) {};
  builtins.elem (lib.getName pkg) [
    "zoom"
  ];
  packageOverrides = pkgs: with pkgs; {
    desktopPackages = pkgs.buildEnv {
      name = "desktopPackages";
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
        zoom-us
      ];
      pathsToLink = [ "/share" "/bin" "/lib" ];
      extraOutputsToInstall = [ "man" "doc" ];
    };
  };
}
# TODO: fix PATH and MANPATH so that docs are available to `man`.
