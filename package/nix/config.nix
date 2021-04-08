{
    pulseaudio = true;
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
            ];
            pathsToLink = [ "/share" "/bin" "/lib" ];
            # TODO: fix PATH and MANPATH so that these are available to `man`.
            extraOutputsToInstall = [ "man" "doc" ];
        };
    };
}
